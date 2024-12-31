import Foundation

public struct PackOutput: Sendable, Codable {
    public enum Version: Int, Codable, Sendable {
        case v1 = 1
    }

    public var version: Version
    public var path: String

    public init(path: String) {
        self.version = .v1
        self.path = path
    }
}
