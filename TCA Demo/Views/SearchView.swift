//
//  SearchView.swift
//  TCA Demo
//
//  Created by Love,Alan on 6/28/21.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    let store: Store<SearchState, SearchAction>

    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                TextField("Product Name",
                    text: viewStore.binding(
                        get: \.query,
                        send: SearchAction.inputChanged
                    )
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                List(viewStore.products, id: \.id) { product in
                    Text(product.id)
                }
            }.padding(10)
        }
    }
}
