//
//  AppCore.swift
//  TCA Demo
//
//  Created by Love,Alan on 6/26/21.
//

import Foundation
import ComposableArchitecture

public struct AppState: Equatable, Codable {
    var storeNumber = 246
    var favorites: FavoritesState = .init()
    var search: SearchState = .init()
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
                state.storeNumber = number!
            }
            return .none
        case .favorites(_):
            return .none
        case .search(_):
            return .none
        }
    }
)
