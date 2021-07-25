import Foundation

extension FavoritesView.State {
    static func fromAppState(_ appState: AppState) -> FavoritesView.State {
        .init(storeNumber: appState.storeNumber, favorites: appState.favorites.favorites)
    }
}

extension FavoritesView.Action {
    var appAction: AppAction {
        switch self {
        }
    }
}
