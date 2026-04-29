//
//  PlayerView.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//
import SwiftUI

struct PlayerView: View {
    let sessionState: ListeningSessionState
    let now: Date
    let onLeave: () -> Void
    let onTogglePlayPause: () -> Void
    let onSeekForward: () -> Void
    let onSeekBackward: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            RoundedRectangle(cornerRadius: 32)
                .fill(.gray.opacity(0.18))
                .frame(width: 280, height: 280)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.system(size: 72))
                        .foregroundStyle(.secondary)
                }

            songInfo

            progressSection

            controls

            sessionStatus

            Spacer()

            Button("Leave Session") {
                onLeave()
            }
            .foregroundStyle(.secondary)
        }
        .padding(24)
        .navigationBarBackButtonHidden(false)
    }

    @ViewBuilder
    private var songInfo: some View {
        if let snapshot = currentSnapshot {
            VStack(spacing: 6) {
                Text(snapshot.title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(snapshot.artist)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var progressSection: some View {
        if let snapshot = currentSnapshot {
            let currentPosition = PlaybackPositionCalculator.currentPosition(
                from: snapshot,
                now: now
            )
            
            VStack(spacing: 8) {
                ProgressView(value: currentPosition, total: snapshot.durationSeconds)
                    .tint(.primary)

                HStack {
                    Text(TimeFormatter.playbackTime(currentPosition))
                    Spacer()
                    Text(TimeFormatter.playbackTime(snapshot.durationSeconds))
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }

    private var controls: some View {
        HStack(spacing: 36) {
            Image(systemName: "backward.fill")
            Image(systemName: "pause.circle.fill")
                .font(.system(size: 54))
            Image(systemName: "forward.fill")
        }
        .font(.title2)
    }

    private var sessionStatus: some View {
        VStack(spacing: 6) {
            Text(statusTitle)
                .font(.headline)

            Text(statusSubtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var currentSnapshot: PlaybackSnapshot? {
        switch sessionState {
        case .partnerListening(let snapshot),
             .listeningAlone(let snapshot),
             .joining(let snapshot),
             .listeningTogether(let snapshot, _):
            return snapshot
        case .idle:
            return nil
        case .reconnecting(let lastSnapshot):
            return lastSnapshot
        }
    }

    private var statusTitle: String {
        switch sessionState {
        case .listeningTogether:
            return "Listening together"
        case .joining:
            return "Joining…"
        case .listeningAlone:
            return "You’re listening"
        case .partnerListening:
            return "She’s listening"
        case .reconnecting:
            return "Reconnecting…"
        case .idle:
            return "Not listening"
        }
    }

    private var statusSubtitle: String {
        switch sessionState {
        case .listeningTogether(_, let sharedSince):
            return "Shared for \(TimeFormatter.sharedDuration(since:sharedSince, now: now))"
        case .joining:
            return "Trying to sync"
        case .listeningAlone:
            return "She can join anytime"
        case .partnerListening:
            return "Tap join from Home"
        case .reconnecting:
            return "Trying to sync again"
        case .idle:
            return ""
        }
    }
}
