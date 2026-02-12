import Sharing
import SwiftUI

struct LogPrefrenceView: View {
    @Shared(.logs) private var logs

    var body: some View {
        SettingsCard(
            title: "Logs",
            subtitle: "Diagnostic history and quick export",
            symbol: "newspaper.fill"
        ) {
            VStack(alignment: .leading, spacing: 10) {
                SettingsRow(
                    title: "Stored entries",
                    subtitle: "Useful when sharing bug reports."
                ) {
                    Text("\(logs.count)")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.92))
                }

                HStack(spacing: 8) {
                    Button {
                        copyLogsToClipboard(redacted: true)
                    } label: {
                        Label("Copy Safe", systemImage: "clipboard.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .tint(Color(red: 0.98, green: 0.38, blue: 0.47))

                    Button {
                        copyLogsToClipboard(redacted: false)
                    } label: {
                        Label("Copy Raw", systemImage: "key.radiowaves.forward.fill")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.white)

                    Button {
                        $logs.withLock { $0.removeAll() }
                    } label: {
                        Label("Clear", systemImage: "trash.fill")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.red)
                }

                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 6) {
                        if logs.isEmpty {
                            Text("No logs yet.")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 4)
                        } else {
                            ForEach(logs, id: \.self) { log in
                                LogText(text: log, color: .white.opacity(0.72))
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(maxHeight: 170)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.black.opacity(0.24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(.white.opacity(0.08), lineWidth: 1)
                        )
                )
            }
        }
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
                .foregroundStyle(color)
                .textSelection(.enabled)
            Spacer()
        }
    }
}
