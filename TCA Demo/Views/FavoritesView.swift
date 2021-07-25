//
//  FavoritesView.swift
//  TCA Demo
//
//  Created by Love,Alan on 6/28/21.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesView: View {
    struct State: Equatable {
        var storeNumber: Int
        var favorites: Set<Product> = []
    }
    
    enum Action {
    }
    
    let store: Store<State, Action>

    public init(store: Store<State, Action>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            Text("Store number in FavoritesView: \(viewStore.storeNumber)")
        }
    }
}
