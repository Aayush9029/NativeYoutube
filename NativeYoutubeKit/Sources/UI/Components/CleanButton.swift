import SwiftUI
import Models

struct CleanButton: View {
    let page: Pages
    let image: String
    @Binding var binded: Pages
    
    init(page: Pages, image: String, binded: Binding<Pages>) {
        self.page = page
        self.image = image
        self._binded = binded
    }
    
    public var body: some View {
        Button {
            binded = page
        } label: {
            Group {
                Label(page.rawValue, systemImage: image)
                    .labelStyle(.iconOnly)
                    .font(.callout)
                    .foregroundStyle(binded == page ? .red : .gray)
                    .fontWeight(.medium)
            }
            .thinRoundedBG(padding: 6, radius: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        binded == page ? .red : .gray.opacity(0.5),
                        lineWidth: 2
                    )
            )
            .padding(1)
        }
        .buttonStyle(.plain)
        .animation(.spring, value: binded)
    }
}

#if DEBUG
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
#endif
