import Foundation

let currentFile = URL(fileURLWithPath: #filePath)
let projectRoot =
    currentFile
    .deletingLastPathComponent()  // Remove 'main.swift'
    .deletingLastPathComponent()  // Remove 'Prepare'
    .deletingLastPathComponent()  // Remove 'Sources'

func generateCode(for sourceDirectory: URL, in targetDirectory: URL) throws {
    // if target directory does not exist, create it
    if !FileManager.default.fileExists(atPath: targetDirectory.path) {
        try! FileManager.default.createDirectory(at: targetDirectory, withIntermediateDirectories: true, attributes: nil)
    }

    let workingDirectory = projectRoot.appendingPathComponent("googleapis")
    let protocCommand = """
    protoc \
    --proto_path=\(workingDirectory.path) \
    --swift_out=Visibility=Public:\(targetDirectory.path) \
    \(sourceDirectory.path)/*.proto
    """
    try runTerminalCommand(protocCommand, workingDirectory: workingDirectory.path)
    
    // Move all .swift files from nested directories to the target directory root
    try flattenSwiftFiles(in: targetDirectory)
}

func flattenSwiftFiles(in targetDirectory: URL) throws {
    let fileManager = FileManager.default
    let enumerator = fileManager.enumerator(at: targetDirectory, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles])
    
    var swiftFiles: [URL] = []
    var emptyDirectories: [URL] = []
    
    // Find all .swift files and collect directories that will become empty
    while let fileURL = enumerator?.nextObject() as? URL {
        let resourceValues = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
        if resourceValues.isRegularFile == true && fileURL.pathExtension == "swift" {
            swiftFiles.append(fileURL)
            // Track the parent directory for potential cleanup
            let parentDir = fileURL.deletingLastPathComponent()
            if parentDir != targetDirectory {
                emptyDirectories.append(parentDir)
            }
        }
    }
    
    // Move all .swift files to the target directory root
    for swiftFile in swiftFiles {
        let fileName = swiftFile.lastPathComponent
        let newLocation = targetDirectory.appendingPathComponent(fileName)
        
        // Only move if it's not already in the target directory
        if swiftFile != newLocation {
            // Remove existing file if it exists
            if fileManager.fileExists(atPath: newLocation.path) {
                try fileManager.removeItem(at: newLocation)
            }
            try fileManager.moveItem(at: swiftFile, to: newLocation)
        }
    }
    
    // Clean up empty directories (in reverse order to remove nested dirs first)
    let uniqueDirectories = Array(Set(emptyDirectories)).sorted { $0.path.count > $1.path.count }
    for directory in uniqueDirectories {
        if directory != targetDirectory {
            // Only remove if directory is empty
            let contents = try fileManager.contentsOfDirectory(atPath: directory.path)
            if contents.isEmpty {
                try fileManager.removeItem(at: directory)
            }
        }
    }
}

@main
struct PrepareMain {

    static func main() throws {
        // googleapis/google/ai/generativelanguage/v1beta3
        let sourceGenerativeLanguage = projectRoot.appendingPathComponent("googleapis/google/ai/generativelanguage/v1beta3")
        let targetGenerativeLanguage = projectRoot.appendingPathComponent("Sources/Generativelanguage/GeneratedSources")

        try generateCode(for: sourceGenerativeLanguage, in: targetGenerativeLanguage)

        let protoDirectoriesToAlwaysInclude = [
            "googleapis/google/longrunning": "GoogleLongRunning",
            "googleapis/google/api": "GoogleAPI",
            "googleapis/google/rpc": "GoogleRPC",
        ]

        for (protoDirectory, targetDirectory) in protoDirectoriesToAlwaysInclude {
            try generateCode(for: projectRoot.appendingPathComponent(protoDirectory), in: projectRoot.appendingPathComponent("Sources/\(targetDirectory)/GeneratedSources"))
        }
    }
}
