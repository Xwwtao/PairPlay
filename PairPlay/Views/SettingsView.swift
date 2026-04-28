//
//  SettingsView.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var quietMode = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Pair") {
                    HStack {
                        Text("Connected with")
                        Spacer()
                        Text("Her")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Status") {
                    statusRow(title: "Apple Music", value: "Ready")
                    statusRow(title: "Connection", value: "Connected")
                    statusRow(title: "Permissions", value: "Granted")
                }

                Section("Listening Mode") {
                    Toggle("Quiet Mode", isOn: $quietMode)
                }

                Section {
                    Button("Retry Connection") {}

                    Button("Disconnect Pair", role: .destructive) {}
                }
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

    private func statusRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}
