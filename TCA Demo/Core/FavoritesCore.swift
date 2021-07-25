import Foundation
import ComposableArchitecture

public struct FavoritesState: Equatable, Codable {
    var favorites: Set<Product> = []
}

public enum FavoritesAction: Equatable {
    case addProduct(id: String)
    case removeProduct(id: String)
}

public struct FavoritesEnvironment {}

public let favoritesReducer = Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment>.combine(
    Reducer { state, action, _ in
        switch action {
        case let .addProduct(id):
            return .none
        case let .removeProduct(id):
            return .none
        }
    }
)
