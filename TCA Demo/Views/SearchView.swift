//
//  SearchView.swift
//  TCA Demo
//
//  Created by Love,Alan on 6/28/21.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    struct State: Equatable {
        var query: String
        var products: [Product]
        var storeNumber: Int
    }
    
    enum Action {
        case inputChanged(String)
        case productTapped(Product)
        case clearInput
    }
        
    let store: Store<State, Action>

    public init(store: Store<State, Action>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("Store number in SearchView: \(viewStore.storeNumber)")
                TextField("Product Name",
                          text: viewStore.binding(
                            get: \.query,
                            send: Action.inputChanged
                          )
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                List(viewStore.products, id: \.id) { product in
                    Text(product.id)
                        .onTapGesture {
                            viewStore.send(.productTapped(product))
                        }
                }
            }.padding(10)
        }
    }
}
