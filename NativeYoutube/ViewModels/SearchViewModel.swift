//
//  YTSearchViewModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
import SwiftyJSON

class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var videos = [VideoModel]()
    @Published var currentStatus: RequestStatus = .none

    let maxResults = "25"

    enum RequestStatus: String, Error {
        case none = "Nothing has happend yet...search something"
        case startedFetching = "Fetching video data"
        case doneFetching = "Fetch was successful"

        case invalidURL = "The api URL is invalid"
        case invalidResponse = "The response we got from server is invalid"

        case unknownError = "I've never seen an error like this before"
    }

    func startSearch(apiKey: String) {
        Task {
            do {
                DispatchQueue.main.sync {
                    self.currentStatus = .startedFetching
                }
                try await self.fetchVideos(apiKey: apiKey)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func fetchVideos(apiKey: String) async throws {
        DispatchQueue.main.sync {
            self.videos = []
        }

        let query = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let searchRequest = SearchRequest(apiKey: apiKey,
                                          query: query,
                                          maxResults: maxResults)

        guard let url = searchRequest.createURL() else {
            DispatchQueue.main.sync {
                self.currentStatus = .invalidURL
            }
            throw RequestStatus.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.sync {
                    self.currentStatus = .invalidResponse
                }
                throw RequestStatus.invalidResponse
            }

            if let json = try? JSON(data: data) {
                let videos = SearchRequest.parseJSON(json: json)
                DispatchQueue.main.async {
                    self.videos = videos
                    self.currentStatus = .doneFetching
                }
            }
        } catch {
            DispatchQueue.main.sync {
                self.currentStatus = .unknownError
            }
            print(error.localizedDescription)
        }
    }
}
