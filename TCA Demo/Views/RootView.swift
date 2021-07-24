//
//  RootView.swift
//  TCA Demo
//
//  Created by Love,Alan on 6/26/21.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
                haystackClient: HaystackClient(),
                mainQueue: .main
        )
    )
    
    var body: some View {
        AppView(store: self.store)
    }
}
