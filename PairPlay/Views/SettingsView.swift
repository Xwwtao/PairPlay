import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    let environmentState: AppEnvironmentState
    let onToggleQuietMode: () -> Void
    let onRetryConnection: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                pairSection
                statusSection
                listeningModeSection
                actionsSection
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var pairSection: some View {
        Section("Pair") {
            VStack(alignment: .leading, spacing: 4) {
                Text(environmentState.pairState.displayTitle)
                    .font(.body)

                Text(environmentState.pairState.displaySubtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    private var statusSection: some View {
        Section("Status") {
            statusRow(
                title: "Apple Music",
                value: environmentState.appleMusicState.displayValue,
                detail: environmentState.appleMusicState.displayDetail
            )

            statusRow(
                title: "Connection",
                value: environmentState.connectionState.displayValue,
                detail: environmentState.connectionState.displayDetail
            )

            statusRow(
                title: "Permissions",
                value: environmentState.appleMusicState.authorization.displayValue,
                detail: "Required for Apple Music playback"
            )
        }
    }

    private var listeningModeSection: some View {
        Section("Listening Mode") {
            Button {
                onToggleQuietMode()
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Quiet Mode")
                            .foregroundStyle(.primary)

                        Text("See partner activity without strong join prompts")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(environmentState.quietModeEnabled ? "On" : "Off")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var actionsSection: some View {
        Section {
            Button("Retry Connection") {
                onRetryConnection()
            }

            Button("Disconnect Pair", role: .destructive) {
                // MVP: no action yet
            }
        }
    }

    private func statusRow(
        title: String,
        value: String,
        detail: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                Text(value)
                    .foregroundStyle(.secondary)
            }

            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}
