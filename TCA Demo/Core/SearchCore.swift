//
//  SearchCore.swift
//  TCA Demo
//
//  Created by Love,Alan on 6/27/21.
//

import Foundation
import ComposableArchitecture

public struct SearchState: Equatable, Codable {
    var query = ""
    var products: [Product] = []
}

public enum SearchAction: Equatable {
    case inputChanged(String)
    case productTapped(Product)
    case clearInput
    case productsResponse(Result<HaystackClient.ProductLookupResponse, HaystackClient.Failure>)
}

public struct SearchEnvironment {
    public var haystackClient: HaystackClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
}

public let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case let .inputChanged(query):
            struct SearchResultId: Hashable {}

            state.query = query

            guard !query.isEmpty else {
                state.products = []

                return .cancel(id: SearchResultId())
            }

            return environment.haystackClient
                .lookupProduct(query: state.query)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .debounce(id: SearchResultId(), for: 0.3, scheduler: environment.mainQueue)
                .map({ data in SearchAction.productsResponse(data) })
                .cancellable(id: SearchResultId(), cancelInFlight: true)

        case .clearInput:
            state.query = ""
            return .none

        case let .productsResponse(.failure(response)):
            state.products = []
            return .none

        case let .productsResponse(.success(response)):
            state.products = response.data.productSearch.records
            return .none

        case let .productTapped(product):
            return .none
        }
    }
).debug()
