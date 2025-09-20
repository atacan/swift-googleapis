import Testing
import SwiftProtobuf
import Foundation
@testable import GenerativeLanguage

@Test func example() async throws {
    let request = Google_Ai_Generativelanguage_V1beta_GenerateContentRequest.with {
        $0.model = "gemini-1.5-flash"
        $0.contents = [
            .with {
                $0.parts = [
                    .with {
                        $0.text = "Hello, how are you?"
                    }
                ]
                $0.role = GenerativeLanguageRole.user.rawValue
            }
        ]
    }

    var options = JSONEncodingOptions()
    options.useDeterministicOrdering = true
    options.preserveProtoFieldNames = false
    try print(request.jsonString(options: options))
}
