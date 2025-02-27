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
    --plugin=/Users/atacan/protoc-gen-grpc-swift \
    --proto_path=\(workingDirectory.path) \
    --swift_out=Visibility=Public:\(targetDirectory.path) \
    --grpc-swift_out=Visibility=Public,Client=true,Server=false:\(targetDirectory.path) \
    \(sourceDirectory.path)/*.proto
    """
    try runTerminalCommand(protocCommand, workingDirectory: workingDirectory.path)
}

@main
struct PrepareMain {

    static func main() throws {
        // googleapis/google/ai/generativelanguage/v1beta
        let sourceGenerativeLanguage = projectRoot.appendingPathComponent("googleapis/google/ai/generativelanguage/v1beta")
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
