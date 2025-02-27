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

    let protocCommand = """
    protoc --swift_out=Visibility=Public:\(targetDirectory.path) \
    --grpc-swift_out=Visibility=Public,Client=true,Server=false:\(targetDirectory.path) \
    *.proto
    """

    try runTerminalCommand(protocCommand, workingDirectory: projectRoot.path)
}

@main
struct PrepareMain {

    static func main() {
        print(projectRoot)
    }
}
