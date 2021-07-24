//
//  AppCore.swift
//  TCA Demo
//
//  Created by Love,Alan on 6/26/21.
//

import Foundation
import ComposableArchitecture

public struct AppState: Equatable {
    var storeNumber = 246
    var favoriteList: Set<Product> = []

    var favorites: FavoritesState {
        get {
            .init(favorites: favoriteList)
        }
        set {
            favoriteList = newValue.favorites
        }
    }
    var search: SearchState {
        get {
            .init(storeNumber: storeNumber, favorites: favoriteList)
        }
        set {
            storeNumber = newValue.storeNumber
            favoriteList = newValue.favorites
        }
    }
}

public enum AppAction: Equatable {
    case favorites(FavoritesAction)
    case search(SearchAction)

    case storeNumberChanged(String)
}

public struct AppEnvironment {
    public var haystackClient: HaystackClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(
        haystackClient: HaystackClient,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.haystackClient = haystackClient
        self.mainQueue = mainQueue
    }
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    favoritesReducer.pullback(
        state: \.favorites,
        action: /AppAction.favorites,
        environment: { _ in FavoritesEnvironment() }
    ),
    searchReducer.pullback(
        state: \.search,
        action: /AppAction.search,
        environment: {
            SearchEnvironment(haystackClient: $0.haystackClient, mainQueue: $0.mainQueue)
        }
    ),
    Reducer { state, action, _ in
        switch action {
        case let .storeNumberChanged(input):
            let number = Int(input)
            if number != nil {
                state.search.storeNumber = number!
            }
            return .none
        case .favorites(_):
            return .none
        case .search(_):
            return .none
        }
    }
)
