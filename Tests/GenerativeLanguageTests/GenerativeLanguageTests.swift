import Testing
import Foundation
@testable import GenerativeLanguage

@Test func example() async throws {
    let request = Google_Ai_Generativelanguage_V1_GenerateContentRequest.with {
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

    
}
