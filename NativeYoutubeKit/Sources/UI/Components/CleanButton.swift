import SwiftUI
import Models

public struct CleanButton: View {
    let page: Pages
    let image: String
    @Binding var binded: Pages
    
    public init(page: Pages, image: String, binded: Binding<Pages>) {
        self.page = page
        self.image = image
        self._binded = binded
    }
    
    public var body: some View {
        Button {
            withAnimation {
                binded = page
            }
        } label: {
            Group {
                Label(page.rawValue, systemImage: image)
                    .labelStyle(.iconOnly)
                    .font(.callout)
                    .foregroundColor(binded == page ? .red : .gray)
            }
            .thinRoundedBG(padding: 6, radius: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        binded == page ? .red : .gray,
                        lineWidth: binded == page ? 2 : 0.5
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var currentPage: Pages = .playlists
        
        var body: some View {
            HStack(spacing: 20) {
                CleanButton(
                    page: .playlists,
                    image: "music.note.list",
                    binded: $currentPage
                )
                
                CleanButton(
                    page: .search,
                    image: "magnifyingglass",
                    binded: $currentPage
                )
                
                CleanButton(
                    page: .settings,
                    image: "gear",
                    binded: $currentPage
                )
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}