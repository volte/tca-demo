import Foundation

public struct ProductBrand: Codable, Equatable, Hashable {
    public var name: String
    public var isOwnBrand: Bool
}

public struct ProductLocation: Codable, Equatable, Hashable {
    public var location: String
    public var availability: String
}

public struct ProductImageUrl: Codable, Equatable, Hashable {
    public var url: String
    public var size: String
}

public struct Product: Identifiable, Codable, Equatable, Hashable {
    public var id: String
    public var fullDisplayName: String
    public var productImageUrls: [ProductImageUrl]
}
