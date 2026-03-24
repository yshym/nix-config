import Foundation

enum MenuProtocol {
    static let cmdDrun = "drun"
    static let cmdReload = "reload"
    static let cmdStop = "stop"
    static let respSelected = "selected"
    static let respCancelled = "cancelled"
    static let respOk = "ok"

    static func socketPath() -> String {
        if let tmpdir = ProcessInfo.processInfo.environment["TMPDIR"] {
            return "\(tmpdir)/menu.sock"
        }
        return "/tmp/menu-\(getuid()).sock"
    }

    static func logPath() -> String {
        if let tmpdir = ProcessInfo.processInfo.environment["TMPDIR"] {
            return "\(tmpdir)/menu-server.log"
        }
        return "/tmp/menu-server-\(getuid()).log"
    }
}
