import Testing
@testable import GenerativeLanguage

import GRPCCore
import GRPCProtobuf
import GRPCNIOTransportHTTP2

@Test func example() async throws {
    try await withGRPCClient(
        transport: .http2NIOPosix(
            target: .ipv4(host: "generativelanguage.googleapis.com"),
            transportSecurity: .tls
        )
    ) { client in
        let greeter = Google_Ai_Generativelanguage_V1beta_GenerativeService.Client(wrapping: client)
        let reply = try await greeter.generateAnswer(request: .init(message: .with({
            $0.model = "gemini-2.0-flash"
            $0.contents = [.with({
                $0.role = "user"
                $0.parts = [.with({
                    $0.text = "Hello, world!"
                })]
            })]
        })))
        
        dump(reply)
    }
    
}
