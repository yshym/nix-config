import Cocoa

private var gSocketPath = ""

private func cleanupSocket() {
    unlink(gSocketPath)
}

func serverRun() -> Never {
    gSocketPath = MenuProtocol.socketPath()

    // Remove stale socket
    fputs("Menu server starting, socket: \(gSocketPath)\n", stderr)
    if unlink(gSocketPath) < 0 && errno != ENOENT {
        perror("unlink")
    }

    // Install signal handlers for clean shutdown
    signal(SIGTERM) { _ in cleanupSocket(); _exit(0) }
    signal(SIGINT) { _ in cleanupSocket(); _exit(0) }
    atexit { cleanupSocket() }

    // Create Unix domain socket
    let serverFd = socket(AF_UNIX, SOCK_STREAM, 0)
    guard serverFd >= 0 else {
        perror("socket")
        exit(1)
    }

    var addr = sockaddr_un()
    addr.sun_family = sa_family_t(AF_UNIX)
    _ = withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
        gSocketPath.withCString { strcpy(ptr, $0) }
    }

    let bindResult = withUnsafePointer(to: &addr) { ptr in
        ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            bind(serverFd, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
        }
    }
    guard bindResult >= 0 else {
        perror("bind")
        close(serverFd)
        exit(1)
    }

    fputs("Menu server bound to \(gSocketPath)\n", stderr)

    guard listen(serverFd, 5) >= 0 else {
        perror("listen")
        close(serverFd)
        exit(1)
    }

    // Create NSApplication
    let nsApp = NSApplication.shared
    nsApp.setActivationPolicy(.accessory)

    // Create AppDelegate in server mode
    let delegate = AppDelegate()
    delegate.serverMode = true
    delegate.clientFd = -1
    delegate.reloadApps()
    nsApp.delegate = delegate

    // Accept connections on a background dispatch queue
    let queue = DispatchQueue(label: "menu.server.accept")
    queue.async {
        while true {
            let clientFd = accept(serverFd, nil, nil)
            guard clientFd >= 0 else { continue }

            // Read command
            var buf = [CChar](repeating: 0, count: 256)
            let n = read(clientFd, &buf, buf.count - 1)
            guard n > 0 else { close(clientFd); continue }
            buf[n] = 0
            let cmd = String(cString: buf)

            // Dispatch to main thread
            if cmd.hasPrefix(MenuProtocol.cmdDrun) {
                DispatchQueue.main.async {
                    delegate.showDrun(clientFd)
                }
            } else if cmd.hasPrefix(MenuProtocol.cmdReload) {
                DispatchQueue.main.async {
                    delegate.reloadApps()
                    let resp = MenuProtocol.respOk + "\n"
                    resp.withCString { _ = write(clientFd, $0, strlen($0)) }
                    close(clientFd)
                }
            } else if cmd.hasPrefix(MenuProtocol.cmdStop) {
                DispatchQueue.main.async {
                    let resp = MenuProtocol.respOk + "\n"
                    resp.withCString { _ = write(clientFd, $0, strlen($0)) }
                    close(clientFd)
                    cleanupSocket()
                    close(serverFd)
                    NSApp.terminate(nil)
                }
            } else {
                close(clientFd)
            }
        }
    }

    // Run the main event loop (never returns)
    nsApp.run()
    exit(0) // unreachable, satisfies Never
}
