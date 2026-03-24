import Cocoa

// ---------------------------------------------------------------------------
// Read lines from stdin
// ---------------------------------------------------------------------------

func readStdin() -> [String] {
    var lines: [String] = []
    while let line = readLine() {
        if !line.isEmpty { lines.append(line) }
    }
    return lines
}

// ---------------------------------------------------------------------------
// Run one-shot mode
// ---------------------------------------------------------------------------

func runOneshot(items: [String], mode: MenuMode, paths: [String: String]) {
    let app = NSApplication.shared
    app.setActivationPolicy(.accessory)
    let delegate = AppDelegate()
    delegate.setup(items: items, mode: mode, appPaths: paths)
    app.delegate = delegate
    app.run()
}

// ---------------------------------------------------------------------------
// Usage
// ---------------------------------------------------------------------------

func usage() {
    fputs("""
        Usage: Menu [--drun] [--server]
          --drun     App launcher mode (scan app directories)
          --server   Use/spawn background server for instant startup
          --reload   Reload app list on running server
          --stop     Stop the background server
          (default)  Read lines from stdin, show menu, print selection
        
        """, stderr)
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

let args = CommandLine.arguments
var drun = false
var withServer = false
var stop = false
var reload = false
var serverInternal = false

for arg in args.dropFirst() {
    switch arg {
    case "--drun":
        drun = true
    case "--server":
        withServer = true
    case "--stop":
        stop = true
    case "--reload":
        reload = true
    case "--_server-internal":
        serverInternal = true
    default:
        usage()
        exit(1)
    }
}

// Internal: start the server process (called after fork+exec)
if serverInternal {
    serverRun()
    // never reached
}

// --stop: tell running server to shut down
if stop {
    let fd = clientConnect()
    guard fd >= 0 else { exit(0) } // no server, nothing to stop
    clientSend(fd, MenuProtocol.cmdStop)
    _ = clientRecv(fd)
    close(fd)
    exit(0)
}

// --reload: tell running server to rescan app directories
if reload {
    let fd = clientConnect()
    guard fd >= 0 else {
        fputs("Menu: no server running\n", stderr)
        exit(1)
    }
    clientSend(fd, MenuProtocol.cmdReload)
    _ = clientRecv(fd)
    close(fd)
    exit(0)
}

// --drun mode
if drun {
    // Try to connect to existing server
    var fd = clientConnect()
    if fd >= 0 {
        // Server running — use it
        clientSend(fd, MenuProtocol.cmdDrun)
        _ = clientRecv(fd)
        close(fd)
        exit(0)
    }
    if withServer {
        // No server — spawn one and retry with backoff
        clientSpawnServer()
        fd = -1
        for _ in 0..<10 {
            fd = clientConnect()
            if fd >= 0 { break }
            usleep(50000) // 50ms between retries
        }
        if fd >= 0 {
            clientSend(fd, MenuProtocol.cmdDrun)
            _ = clientRecv(fd)
            close(fd)
            exit(0)
        }
        fputs("Menu: failed to connect to server\n", stderr)
        exit(1)
    }
    // No server, no --server flag — one-shot mode
    let result = scanApps()
    runOneshot(items: result.items, mode: .drun, paths: result.paths)
    exit(0)
}

// stdin mode (always one-shot)
guard isatty(STDIN_FILENO) == 0 else {
    usage()
    exit(1)
}
let items = readStdin()
runOneshot(items: items, mode: .stdin, paths: [:])
