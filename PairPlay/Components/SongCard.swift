//
//  SongCard.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//

import SwiftUI

struct SongCard: View {
    let snapshot: PlaybackSnapshot
    var buttonTitle: String = "Join Listening"
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RoundedRectangle(cornerRadius: 24)
                .fill(.gray.opacity(0.18))
                .frame(height: 220)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.system(size: 56))
                        .foregroundStyle(.secondary)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(snapshot.title)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(snapshot.artist)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: snapshot.positionSeconds, total: snapshot.durationSeconds)
                .tint(.primary)

            HStack {
                Text(timeText(snapshot.positionSeconds))
                Spacer()
                Text(timeText(snapshot.durationSeconds))
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Button {
                action()
            } label: {
                Text(buttonTitle)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(buttonTitle == "Syncing")
        }
        .padding(18)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    private func timeText(_ seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
