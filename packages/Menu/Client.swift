import Foundation
import MachO

func clientConnect() -> Int32 {
    let path = MenuProtocol.socketPath()
    let fd = socket(AF_UNIX, SOCK_STREAM, 0)
    guard fd >= 0 else { return -1 }

    var addr = sockaddr_un()
    addr.sun_family = sa_family_t(AF_UNIX)
    let maxLen = MemoryLayout.size(ofValue: addr.sun_path) - 1
    _ = withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
        path.withCString { strncpy(ptr, $0, maxLen) }
    }

    let result = withUnsafePointer(to: &addr) { ptr in
        ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            connect(fd, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
        }
    }
    guard result >= 0 else { close(fd); return -1 }
    return fd
}

func clientSend(_ fd: Int32, _ msg: String) {
    msg.withCString { ptr in
        _ = write(fd, ptr, strlen(ptr))
    }
}

func clientRecv(_ fd: Int32) -> String? {
    var buf = [CChar](repeating: 0, count: 512)
    var total = 0
    while total < buf.count - 1 {
        let n = read(fd, &buf[total], buf.count - 1 - total)
        if n <= 0 { break }
        total += n
        if buf[total - 1] == 0x0A { break } // newline
    }
    buf[total] = 0
    // Strip trailing newline
    if total > 0 && buf[total - 1] == 0x0A { buf[total - 1] = 0 }
    let str = String(cString: buf)
    return str.isEmpty ? nil : str
}

func clientSpawnServer() {
    // Resolve the absolute path of the current binary
    var selfPath = [CChar](repeating: 0, count: 1024)
    var size = UInt32(selfPath.count)
    guard _NSGetExecutablePath(&selfPath, &size) == 0 else {
        fputs("Menu: failed to resolve executable path\n", stderr)
        return
    }

    let logPath = MenuProtocol.logPath()
    FileManager.default.createFile(atPath: logPath, contents: nil)

    let process = Process()
    process.executableURL = URL(fileURLWithPath: String(cString: selfPath))
    process.arguments = ["--_server-internal"]
    process.standardInput = FileHandle.nullDevice
    process.standardOutput = FileHandle(forWritingAtPath: logPath)
    process.standardError = FileHandle(forWritingAtPath: logPath)
    try? process.run()

    // Brief initial wait for server to start
    usleep(50000) // 50ms
}
