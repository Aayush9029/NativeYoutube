//
//  SearchView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel

    var body: some View {
        Group {
            VStack {
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(AppStateViewModel())
    }
}
