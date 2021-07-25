import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            TabView {
                VStack {
                    Text("Store Number")
                    HStack {
                        TextField("Store Number",
                            text: viewStore.binding(
                                get: { storeNumber in
                                    return String(viewStore.storeNumber)
                                },
                                send: AppAction.storeNumberChanged
                            )
                        )
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(32)
                    }
                }
                    .tabItem {
                        Text("Store Number \(viewStore.storeNumber)")
                    }
                FavoritesView(store:
                                self.store.scope(
                                    state: FavoritesView.State.fromAppState,
                                    action: { $0.appAction }
                                )
                )
                    .tabItem {
                        Text("Favorites \(viewStore.favorites.favorites.count)")
                    }
                SearchView(store:
                            self.store.scope(
                                state: SearchView.State.fromAppState,
                                action: { $0.appAction }
                            )
                )
                    .tabItem {
                        Text("Search \(viewStore.storeNumber)")
                    }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(haystackClient: HaystackClient(), mainQueue: .main)
        )

        return AppView(store: store)
    }
}
