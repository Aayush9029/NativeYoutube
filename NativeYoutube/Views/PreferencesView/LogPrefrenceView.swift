import Shared
import SwiftUI
import UI

struct LogPrefrenceView: View {
    @Shared(.logs) private var logs

    var body: some View {
        Group {
            DisclosureGroup {
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(logs, id: \.self) { log in
                                LogText(text: log, color: .gray)
                            }
                        }
                    }
                }
            }
            label: {
                HStack {
                    Label("Logs", systemImage: "newspaper.fill")
                        .bold()
                        .padding(.top, 5)

                    Spacer()

                    Label("Copy", systemImage: "clipboard.fill")
                        .labelStyle(.iconOnly)
                        .thinRoundedBG(padding: 8, material: .thinMaterial)
                        .clipShape(Circle())
                        .onTapGesture {
                            copyLogsToClipboard(redacted: true)
                        }
                        .contextMenu {
                            VStack {
                                Button {
                                    copyLogsToClipboard(redacted: false)
                                } label: {
                                    Label("Copy Raw", systemImage: "key.radiowaves.forward.fill")
                                }

                                Button {
                                    copyLogsToClipboard(redacted: true)
                                } label: {
                                    Label("Copy Redacted", systemImage: "eyes.inverse")
                                }

                                Button {
                                    $logs.withLock { $0.removeAll() }
                                } label: {
                                    Label("Clear Logs", systemImage: "trash.fill")
                                }
                            }
                        }
                }
            }
        }
        .thinRoundedBG()
    }

    private func copyLogsToClipboard(redacted: Bool) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()

        var logsString = logs.joined(separator: "\n")

        if redacted {
            logsString = logsString.replacingOccurrences(of: "AIzaSy[A-Za-z0-9_-]{33}", with: "[[PRIVATE API KEY]]", options: .regularExpression)
        }

        pasteboard.setString(logsString, forType: .string)
    }
}

#if DEBUG
#Preview {
    LogPrefrenceView()
}
#endif

private struct LogText: View {
    let text: String
    let color: Color

    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(color)
                .textSelection(.enabled)
            Spacer()
        }
    }
}
