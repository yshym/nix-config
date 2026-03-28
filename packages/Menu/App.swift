import Cocoa

enum MenuMode { case stdin, drun }

class AppDelegate: NSObject, NSApplicationDelegate,
    NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {

    var panel: NSPanel!
    var searchField: NSTextField!
    var tableView: NSTableView!
    var scrollView: NSScrollView!
    var items: [String] = []
    var filteredItems: [String] = []
    var scoredItems: [ScoredItem]?
    var appPaths: [String: String] = [:]
    var mode: MenuMode = .stdin
    var serverMode = false
    var clientFd: Int32 = -1


    // MARK: - Initialization

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupPanel()
        if !serverMode {
            filteredItems = items
            tableView.reloadData()
            show()
        }
    }

    func setup(items: [String], mode: MenuMode, appPaths: [String: String]) {
        self.items = items
        self.mode = mode
        self.appPaths = appPaths
        self.serverMode = false
        self.clientFd = -1
    }

    func reloadApps() {
        let result = scanApps()
        items = result.items
        appPaths = result.paths
    }

    // MARK: - Panel Setup

    func setupPanel() {
        let panelWidth: CGFloat = 600

        // Derive panel height from Theme.lineCount
        let rowHeight: CGFloat = 28
        let intercellSpacing: CGFloat = 2
        let topPadding: CGFloat = 12
        let searchFieldHeight: CGFloat = 32
        let searchTableGap: CGFloat = 12
        let bottomPadding: CGFloat = 12
        let rowTotal = CGFloat(Theme.lineCount) * (rowHeight + intercellSpacing)
        let panelHeight = topPadding + searchFieldHeight + searchTableGap + rowTotal + bottomPadding

        panel = NSPanel(
            contentRect: NSMakeRect(0, 0, panelWidth, panelHeight),
            styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        centerPanel()
        panel.level = .floating
        panel.titlebarAppearsTransparent = true
        panel.titleVisibility = .hidden
        panel.isMovableByWindowBackground = true
        panel.hidesOnDeactivate = true
        panel.backgroundColor = Theme.hex(Theme.colorBG)

        let contentView = panel.contentView!

        // Search field
        switch Theme.inputType {
        case .bezeled:
            searchField = NSTextField(frame: NSMakeRect(12, panelHeight - topPadding - searchFieldHeight, panelWidth - 24, searchFieldHeight))
            searchField.font = .systemFont(ofSize: Theme.fontSizeSearch)
            searchField.textColor = Theme.hex(Theme.colorFG)
            searchField.backgroundColor = Theme.hex(Theme.colorSel)
            searchField.focusRingType = .none
            searchField.isBordered = false
            searchField.isBezeled = true
            searchField.bezelStyle = .roundedBezel
            searchField.placeholderString = "Search..."
            searchField.delegate = self
            contentView.addSubview(searchField)

        case .simple:
            let searchY = panelHeight - topPadding - searchFieldHeight
            let searchH = searchFieldHeight
            let tableInternalOffset: CGFloat = 12
            let inputX = 12 + Theme.contentPadding + tableInternalOffset
            let searchContainer = NSView(frame: NSMakeRect(0, searchY, panelWidth, searchH))
            searchContainer.wantsLayer = true
            searchContainer.layer?.backgroundColor = Theme.hex(Theme.colorBG).cgColor
            contentView.addSubview(searchContainer)

            let prompt = NSTextField(labelWithString: ">")
            prompt.font = .systemFont(ofSize: Theme.fontSizeSearch)
            prompt.textColor = Theme.hex(Theme.colorSel)
            prompt.frame = NSMakeRect(0, 0, inputX, searchH)
            prompt.alignment = .center
            prompt.drawsBackground = false
            searchContainer.addSubview(prompt)

            searchField = NSTextField(frame: NSMakeRect(inputX, 0, panelWidth - inputX - 12, searchH))
            searchField.font = .systemFont(ofSize: Theme.fontSizeSearch)
            searchField.textColor = Theme.hex(Theme.colorFG)
            searchField.focusRingType = .none
            searchField.isBordered = false
            searchField.isBezeled = false
            searchField.drawsBackground = false
            searchField.placeholderString = "Search..."
            searchField.delegate = self
            searchContainer.addSubview(searchField)
        }

        // Scroll view + table view
        scrollView = NSScrollView(frame: NSMakeRect(12, bottomPadding, panelWidth - 24, rowTotal))
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.hasVerticalScroller = true
        scrollView.scrollerStyle = .overlay
        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder

        tableView = NSTableView(frame: scrollView.bounds)
        tableView.style = .plain;
        let col = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        col.width = panelWidth - 40
        tableView.addTableColumn(col)
        tableView.headerView = nil
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = rowHeight
        tableView.backgroundColor = .clear
        tableView.selectionHighlightStyle = .regular
        tableView.intercellSpacing = NSMakeSize(0, intercellSpacing)

        scrollView.documentView = tableView
        contentView.addSubview(scrollView)

        // Recenter panel on display configuration change (server mode)
        NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.centerPanel()
        }

        // Keyboard event monitor
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return event }

            // Forward Cmd shortcuts
            if event.modifierFlags.contains(.command) {
                if let chars = event.charactersIgnoringModifiers {
                    switch chars {
                    case "a":
                        self.searchField.selectText(nil)
                        return nil
                    case "c":
                        NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: nil)
                        return nil
                    case "v":
                        NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: nil)
                        return nil
                    case "x":
                        NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: nil)
                        return nil
                    default:
                        break
                    }
                }
            }

            switch event.keyCode {
            case 36: // Return
                self.selectItem()
                return nil
            case 53: // Escape
                self.cancel()
                return nil
            case 125: // Down arrow
                let row = self.tableView.selectedRow
                let count = self.filteredItems.count
                if row < count - 1 {
                    self.tableView.selectRowIndexes(IndexSet(integer: row + 1), byExtendingSelection: false)
                    self.tableView.scrollRowToVisible(row + 1)
                }
                return nil
            case 126: // Up arrow
                let row = self.tableView.selectedRow
                if row > 0 {
                    self.tableView.selectRowIndexes(IndexSet(integer: row - 1), byExtendingSelection: false)
                    self.tableView.scrollRowToVisible(row - 1)
                }
                return nil
            default:
                return event
            }
        }
    }

    // MARK: - Panel Positioning

    func centerPanel() {
        guard let screen = NSScreen.main else { return }
        let panelX = (screen.frame.width - panel.frame.width) / 2
        let panelY = (screen.frame.height - panel.frame.height) / 2 + screen.frame.height * 0.1
        panel.setFrameOrigin(NSMakePoint(panelX, panelY))
    }

    // MARK: - Show / Hide

    func show() {
        searchField.stringValue = ""
        filteredItems = items
        scoredItems = nil
        tableView.reloadData()
        if !filteredItems.isEmpty {
            tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        }
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        panel.makeFirstResponder(searchField)
    }

    func hide() {
        panel.orderOut(nil)
        NSApp.hide(nil)
    }

    func showDrun(_ fd: Int32) {
        // Replace the client fd without cancelling/hiding/restoring focus
        if clientFd >= 0 {
            sendResponse(MenuProtocol.respCancelled, to: clientFd)
            close(clientFd)
        }
        clientFd = fd
        mode = .drun
        show()
    }

    // MARK: - Selection / Cancellation

    func selectItem() {
        let row = tableView.selectedRow
        guard row >= 0, row < filteredItems.count else {
            cancel()
            return
        }
        let selected = filteredItems[row]

        if serverMode {
            if let path = appPaths[selected] {
                NSWorkspace.shared.open(URL(fileURLWithPath: path))
            }
            if clientFd >= 0 {
                sendResponse(MenuProtocol.respSelected, to: clientFd)
                close(clientFd)
                clientFd = -1
            }
            hide()
        } else {
            if mode == .drun {
                if let path = appPaths[selected] {
                    NSWorkspace.shared.open(URL(fileURLWithPath: path))
                }
            } else {
                print(selected)
            }
            exit(0)
        }
    }

    func cancel() {
        if serverMode {
            if clientFd >= 0 {
                sendResponse(MenuProtocol.respCancelled, to: clientFd)
                close(clientFd)
                clientFd = -1
            }
            hide()
        } else {
            exit(0)
        }
    }

    func applicationDidResignActive(_ notification: Notification) {
        if panel.isVisible {
            cancel()
        }
    }

    // MARK: - Socket Response Helper

    private func sendResponse(_ resp: String, to fd: Int32) {
        let msg = resp + "\n"
        msg.withCString { ptr in
            _ = write(fd, ptr, strlen(ptr))
        }
    }

    // MARK: - Filtering (NSTextFieldDelegate)

    func controlTextDidChange(_ notification: Notification) {
        let query = searchField.stringValue
        if query.isEmpty {
            filteredItems = items
            scoredItems = nil
        } else {
            var scored: [ScoredItem] = []
            for item in items {
                let r = fuzzyMatch(query: query, item: item)
                if r.match {
                    scored.append(ScoredItem(text: item, score: r.score, matchIndices: r.matchIndices))
                }
            }
            scored.sort {
                if $0.score != $1.score { return $0.score > $1.score }
                return $0.text < $1.text
            }
            scoredItems = scored
            filteredItems = scored.map { $0.text }
        }
        tableView.reloadData()
        if !filteredItems.isEmpty {
            tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
            tableView.scrollRowToVisible(0)
        }
    }

    // MARK: - NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        filteredItems.count
    }

    // MARK: - NSTableViewDelegate

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let container = NSView(frame: NSMakeRect(0, 0, tableColumn?.width ?? 0, 28))

        let text = filteredItems[row]
        let attrStr = NSMutableAttributedString(string: text, attributes: [
            .foregroundColor: Theme.hex(Theme.colorFG),
            .font: NSFont.systemFont(ofSize: Theme.fontSizeList)
        ])

        if let scored = scoredItems, row < scored.count {
            for idx in scored[row].matchIndices {
                let range = NSRange(location: idx, length: 1)
                attrStr.addAttribute(.foregroundColor, value: Theme.hex(Theme.colorAccent), range: range)
                attrStr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            }
        }

        let cellLeftPadding: CGFloat = 12

        let cell = NSTextField(labelWithAttributedString: attrStr)
        cell.drawsBackground = false
        cell.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(cell)
        cell.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        cell.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Theme.contentPadding + cellLeftPadding).isActive = true
        cell.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Theme.contentPadding).isActive = true
        return container
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        MenuRowView()
    }
}
