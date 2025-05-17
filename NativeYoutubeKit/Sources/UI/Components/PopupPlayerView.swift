import SwiftUI

public struct PopupPlayerView<Content: View>: View {
    let title: String
    let onClose: () -> Void
    let content: () -> Content
    
    @State private var isHoveringOnPlayer = false
    
    public init(
        title: String,
        onClose: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.onClose = onClose
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            content()
                .background(Color.black)
            
            if isHoveringOnPlayer {
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.black.opacity(0.7)))
                        .padding()
                }
                .buttonStyle(.plain)
                .transition(.opacity)
            }
        }
        .onHover { hovering in
            withAnimation {
                isHoveringOnPlayer = hovering
            }
        }
    }
}

// Convenience initializer for loading state
public extension PopupPlayerView where Content == AnyView {
    init(
        title: String,
        isLoading: Bool,
        errorMessage: String? = nil,
        onClose: @escaping () -> Void,
        onRetry: (() -> Void)? = nil
    ) {
        self.init(title: title, onClose: onClose) {
            AnyView(
                Group {
                    if isLoading {
                        VStack(spacing: 20) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5)
                            Text("Loading video...")
                                .font(.headline)
                            Text(title)
                                .font(.subheadline)
                                .frame(width: 420)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(width: 600, height: 400)
                    } else if let error = errorMessage {
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.yellow)
                            Text("Video Playback Error")
                                .font(.headline)
                            Text(error)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .frame(width: 420)
                                .foregroundStyle(.secondary)
                            if let retry = onRetry {
                                Button("Retry", action: retry)
                                    .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        .frame(width: 600, height: 400)
                    }
                }
            )
        }
    }
}