import Foundation

public struct PackOutput: Sendable, Codable {
    public enum Errors: Error {
        case versionMismatch(expected: Int, actual: Int)
    }

    private static let version = 1

    public var path: String

    public init(path: String) {
        self.path = path
    }
}

extension PackOutput {
    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        return encoder
    }()

    private static let decoder = JSONDecoder()

    private struct Wrapper: Codable {
        var version: Int
        var output: PackOutput

        enum CodingKeys: CodingKey {
            case version
        }

        init(output: PackOutput) {
            self.version = PackOutput.version
            self.output = output
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.version = try container.decode(Int.self, forKey: .version)
            guard version == PackOutput.version else {
                throw Errors.versionMismatch(expected: PackOutput.version, actual: version)
            }
            self.output = try decoder.singleValueContainer().decode(PackOutput.self)
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.version, forKey: .version)
            try self.output.encode(to: encoder)
        }
    }

    public static func decode(_ data: Data) throws -> PackOutput {
        try Self.decoder.decode(Wrapper.self, from: data).output
    }

    public func encode() throws -> Data {
        try Self.encoder.encode(Wrapper(output: self))
    }
}
