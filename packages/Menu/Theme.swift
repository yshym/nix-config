import Cocoa

enum Theme {
    static let colorBG     = 0x282A36
    static let colorFG     = 0xF8F8F2
    static let colorSel    = 0x44475A
    static let colorAccent = 0xBD93F9
    static let colorInput  = 0x1E1F2E

    static let fontSizeSearch: CGFloat = 18
    static let fontSizeList: CGFloat = 14

    static func hex(_ value: Int) -> NSColor {
        NSColor(
            red: CGFloat((value >> 16) & 0xFF) / 255.0,
            green: CGFloat((value >> 8) & 0xFF) / 255.0,
            blue: CGFloat(value & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
