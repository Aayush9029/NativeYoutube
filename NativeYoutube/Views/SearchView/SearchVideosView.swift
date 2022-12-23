//
//  SearchView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    @StateObject var searchViewModel = SearchViewModel()

    var body: some View {
        Group {
            ZStack(alignment: .center) {
                VStack {
                    HStack {
                        TextField("Search..", text: $searchViewModel.searchQuery)
                            .textFieldStyle(.plain)
                            .padding(8)
                            .background(.gray.opacity(0.125))
                            .cornerRadius(6)
                            .padding(.horizontal)
                            .onSubmit {
                                searchViewModel.startSearch(apiKey: appStateViewModel.apiKey)
                                appStateViewModel.addToLogs(for: .search, message: "Searching for \($searchViewModel.searchQuery)")
                            }
                    }
                    .padding(.top, 6)
                    Spacer()
                    Group {
                        switch searchViewModel.currentStatus {
                        case .none,
                             .doneFetching:
                            VideoListView(videos: searchViewModel.videos)
                        case .startedFetching:
                            EmptyView()
                        default:
                            SomethingWentWrongView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if searchViewModel.currentStatus == .startedFetching {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(AppStateViewModel())
    }
}
