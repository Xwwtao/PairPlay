//
//  PlaybackSyncService.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/5/1.
//

import Foundation

protocol PlaybackSyncService: AnyObject {
    func startListening(onSnapshotReceived: @escaping @MainActor (PlaybackSnapshot) -> Void)
    func sendSnapshot(_ snapshot: PlaybackSnapshot) async
}

protocol DebugPlaybackSyncService: PlaybackSyncService {
    func simulateIncomingSnapshot(_ snapshot: PlaybackSnapshot)
}

final class MockPlaybackSyncService: DebugPlaybackSyncService {
    private var onSnapshotReceived: (@MainActor (PlaybackSnapshot) -> Void)?
    private(set) var sentSnapshots: [PlaybackSnapshot] = []

    func startListening(onSnapshotReceived: @escaping @MainActor (PlaybackSnapshot) -> Void) {
        self.onSnapshotReceived = onSnapshotReceived
    }

    func sendSnapshot(_ snapshot: PlaybackSnapshot) async {
        sentSnapshots.append(snapshot)
    }

    @MainActor
    func simulateIncomingSnapshot(_ snapshot: PlaybackSnapshot) {
        onSnapshotReceived?(snapshot)
    }
}
