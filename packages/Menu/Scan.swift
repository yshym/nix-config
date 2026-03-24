import Foundation

private let appDirs = [
    "/System/Applications",
    "/System/Applications/Utilities",
    "/System/Library/CoreServices",
    "/Applications",
    "/Applications/Utilities",
]

func scanApps() -> (items: [String], paths: [String: String]) {
    var items: [String] = []
    var paths: [String: String] = [:]
    let dirs = appDirs + [NSHomeDirectory() + "/Applications/Nix"]
    let fm = FileManager.default

    for dir in dirs {
        guard let contents = try? fm.contentsOfDirectory(atPath: dir) else { continue }
        for entry in contents where entry.hasSuffix(".app") {
            let name = (entry as NSString).deletingPathExtension
            if paths[name] == nil {
                paths[name] = "\(dir)/\(entry)"
                items.append(name)
            }
        }
    }
    return (items.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }, paths)
}
