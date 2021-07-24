//
//  FavoritesView.swift
//  TCA Demo
//
//  Created by Love,Alan on 6/28/21.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesView: View {
    let store: Store<FavoritesState, FavoritesAction>

    public init(store: Store<FavoritesState, FavoritesAction>) {
        self.store = store
    }

    var body: some View {
        Text("Favorites")
    }
}
