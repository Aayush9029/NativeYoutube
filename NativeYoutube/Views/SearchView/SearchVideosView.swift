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
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(spacing: 14) {
                        TextField("Search..", text: $searchViewModel.searchQuery)
                            .textFieldStyle(.plain)
                            .padding(8)
                            .background(Color(nsColor: NSColor.windowBackgroundColor))
                            .cornerRadius(8)

                        SearchButton()
                            .onTapGesture {
                                searchViewModel.startSearch(apiKey: appStateViewModel.apiKey)
                                appStateViewModel.addToLogs(for: .search, message: "Searching for \($searchViewModel.searchQuery)")
                            }
                    }
                    .padding([.horizontal, .top])
                    Group {
                        switch searchViewModel.currentStatus {
                        case .none, .doneFetching:
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

struct SearchButton: View {
    var body: some View {
        Group {
            Text("Search")
                .font(.callout)
        }
        .padding(8)
        .background(Color(nsColor: .controlColor))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.125), radius: 1, x: 0, y: 1)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(AppStateViewModel())
    }
}

extension SearchView {
    func toggleSidebar() {
        DispatchQueue.main.async {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        }
    }
}
