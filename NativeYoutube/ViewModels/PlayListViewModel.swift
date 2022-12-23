//
//  YTDataViewModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
import SwiftyJSON

class PlayListViewModel: ObservableObject {
    @Published var videos = [VideoModel]()
    @Published var currentStatus: RequestStatus = .none

    let maxResults = "25"

    enum RequestStatus: String, Error {
        case none = "Nothing has happend yet...do something"
        case startedFetching = "Fetching playlist data"
        case doneFetching = "Fetch was successful"

        case invalidURL = "The Playlist URL is invalid"
        case invalidResponse = "The response we got from server is invalid"
        case unknownError = "I've never seen an error like this before"
    }

    func startFetch(apiKey: String, playListID: String) {
        Task {
            do {
                DispatchQueue.main.sync {
                    self.currentStatus = .startedFetching
                }
                try await self.fetchPlayListVideos(apiKey: apiKey, playListID: playListID)
            } catch {
                print("Couldn't load playlist videos")
            }
        }
    }

    private func fetchPlayListVideos(apiKey: String, playListID: String) async throws {
        DispatchQueue.main.sync {
            self.videos = []
        }

        let playlistsRequest = PlaylistsRequest(apiKey: apiKey,
                                                playListID: playListID,
                                                maxResults: maxResults)

        guard let url = playlistsRequest.createURL() else {
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
                let videos = PlaylistsRequest.parseJSON(json: json)
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
