@_exported import GoogleAPI
@_exported import GoogleLongRunning
@_exported import GoogleRPC

public enum GenerativeLanguageRole: String, CaseIterable {
    case user = "user"
    case model = "model"
}
