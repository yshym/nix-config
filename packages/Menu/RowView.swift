import Cocoa

class MenuRowView: NSTableRowView {
    override func drawSelection(in dirtyRect: NSRect) {
        Theme.hex(Theme.colorSel).setFill()
        NSBezierPath.fill(bounds)
    }
}
