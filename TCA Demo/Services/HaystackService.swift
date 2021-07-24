import Foundation
import ComposableArchitecture

public struct HaystackClient {
    public static let API_ADDRESS = "https://www.heb.com/graphql"

    public struct Failure: Error, Equatable {}

    public struct ProductLookupResponse: Codable, Equatable {
        public struct ProductSearchResponse: Codable, Equatable {
            var productSearch: ProductSearchResponseData
        }

        public struct ProductSearchResponseData: Codable, Equatable {
            var records: [Product]
        }

        public var data: ProductSearchResponse
    }

    func createSearchQueryString(query: String) -> String {
        "{\"operationName\":\"InitialSearchProducts\",\"variables\":{\"limit\":60,\"doNotSuggestPhrase\":false,\"offset\":0,\"query\":\"\(query)\",\"shoppingContext\":\"CURBSIDE_PICKUP\",\"sortBy\":\"SCORE\",\"sortDirection\":\"DESC\",\"storeId\":92,\"segmentIds\":[\"ea41f8e5-aee8-4ff5-a633-c8b7f1c3d9dd\",\"37b60cc5-9238-4653-a08f-fb617a878ef7\",\"881bf27d-a875-4b05-8732-87be803eeaa5\",\"5fb78785-4f40-4c03-8b71-17b118f8fe24\",\"a18f9694-f14d-41d7-9da7-68934bb3d229\",\"af84966d-abec-4a11-94bd-632a651d1d51\",\"e8f8bbb1-5d89-432a-b35a-0f5fedf9d816\",\"cc63cdb9-1f6b-4511-bc43-b598e6b13787\",\"46ec5fd1-5d1d-4837-855d-cd5da948544b\",\"c5a29a56-fbbc-4395-995f-96d382387c79\",\"7a91fbe1-2074-457e-b6dd-454ee8bf8d74\",\"c38d96c1-2242-4b0b-9a24-6c96af12a452\",\"52f600bd-b66c-4e92-94b0-b88c16893828\",\"4b328bfd-0256-4f8a-9a8b-51aed5a9079c\",\"116d472f-da6c-4e24-920d-dfd6ca98b818\",\"bb98a6c0-12cb-45ee-b8f3-2cb7540ef1b7\",\"639c5e3b-f2b7-4ddc-9382-3d73963f24e5\",\"9cdc9da1-e6c0-425b-8d4b-663cd2bc351f\",\"Wine Delivery Stores\",\"Wimberley 708 Exclude\",\"Holiday Hours minus eStores open Thanksgiving Day\",\"Meyerland Exclude\",\"Deli Meal Deal Targeted - Core\",\"Houston and NWFD Region CSD Stores EXCLUDE\",\"OMP BetterBody\",\"Bakery Scratch Bread Stores\",\"HRM Free CSHD Nov 2020\",\"GM NO SEASONAL DECOR\",\"HL Event Remaining Stores\",\"OMP Nature's Heart\",\"Curbside ONLY View\",\"OMP Knorr Segment\",\"OMP SimplyMM Segment\",\"MD- Core\",\"Hurricane Houston Stores Exclude\",\"Bakery Tortilla Stores\",\"Lubbock 1 Corp 772 EXCLUDE\",\"Unilever MM - (Stores w CS-HD Fee)\",\"ID ends with 0 2 4 6 8\",\"Weekly Ad Stores\",\"In-house Roasted Meats Stores\",\"HL Event April\",\"OMP Wonderful\",\"Segment E\",\"SNAP EBT Stores\",\"Segment C\",\"Segment B\",\"10_23 NYX Halloween Makeup Stores\",\"Bakery Bread Stores\",\"OMP Freschetta\",\"Lubbock Exclude\",\"HL Event July\",\"CurbsideView\",\"Wine Mem Day 2020 Pick Six SAFD - Border - Gulf\"],\"ignoreRules\":false,\"timeSlotStartTime\":null,\"addressAllowAlcohol\":false},\"extensions\":{\"persistedQuery\":{\"version\":1,\"sha256Hash\":\"a72524ae937fd8f981bc7eeeebaad52cc8ffef39a6b82b9a93e3431df0acd295\"}}}"
    }

    public func lookupProduct(query: String) -> Effect<ProductLookupResponse, Failure> {
        let requestData = createSearchQueryString(query: query)

        let requestUrl = URL(string: HaystackClient.API_ADDRESS)!

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData.data(using: .ascii)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let response = element.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw Failure()
                }

                return element.data
            }
            .decode(type: HaystackClient.ProductLookupResponse.self, decoder: JSONDecoder())
            .breakpointOnError()
            .mapError { _ in Failure() }
            .eraseToEffect()
    }
}
