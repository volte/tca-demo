import Foundation

extension SearchView.State {
    static func fromAppState(_ appState: AppState) -> SearchView.State {
        .init(query: appState.search.query, products: appState.search.products, storeNumber: appState.storeNumber)
    }
}

extension SearchView.Action {
    var appAction: AppAction {
        switch self {
        case .inputChanged(let input):
            return .search(.inputChanged(input))
        case .productTapped(let product):
            return .search(.productTapped(product))
        case .clearInput:
            return .search(.clearInput)
        }
    }
}
