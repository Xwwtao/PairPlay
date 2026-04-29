//
//  SyncReducer.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/29.
//
import Foundation

enum SyncReducer {
    static func applySnapshot(
        _ incomingSnapshot: PlaybackSnapshot,
        to currentState: ListeningSessionState
    ) -> ListeningSessionState {
        guard shouldAccept(incomingSnapshot, currentState: currentState) else {
            print("Ignored old snapshot. sequence = \(incomingSnapshot.sequence)")
            return currentState
        }

        switch currentState {
        case .idle:
            return .partnerListening(snapshot: incomingSnapshot)

        case .partnerListening:
            return .partnerListening(snapshot: incomingSnapshot)

        case .listeningAlone:
            return .partnerListening(snapshot: incomingSnapshot)

        case .joining:
            return .joining(snapshot: incomingSnapshot)

        case .listeningTogether(_, let sharedSince):
            return .listeningTogether(
                snapshot: incomingSnapshot,
                sharedSince: sharedSince
            )

        case .reconnecting:
            return .partnerListening(snapshot: incomingSnapshot)
        }
    }

    static func applyLocalSnapshot(
        _ localSnapshot: PlaybackSnapshot,
        to currentState: ListeningSessionState
    ) -> ListeningSessionState {
        switch currentState {
        case .idle:
            return .listeningAlone(snapshot: localSnapshot)

        case .partnerListening:
            return .partnerListening(snapshot: localSnapshot)

        case .listeningAlone:
            return .listeningAlone(snapshot: localSnapshot)

        case .joining:
            return .joining(snapshot: localSnapshot)

        case .listeningTogether(_, let sharedSince):
            return .listeningTogether(
                snapshot: localSnapshot,
                sharedSince: sharedSince
            )

        case .reconnecting:
            return .reconnecting(lastSnapshot: localSnapshot)
        }
    }

    static func currentSnapshot(
        from state: ListeningSessionState
    ) -> PlaybackSnapshot? {
        switch state {
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

    private static func shouldAccept(
        _ incomingSnapshot: PlaybackSnapshot,
        currentState: ListeningSessionState
    ) -> Bool {
        guard let currentSnapshot = currentSnapshot(from: currentState) else {
            return true
        }

        return incomingSnapshot.sequence > currentSnapshot.sequence
    }
}
