//
//  ListeningSessionState.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//

import Foundation

enum ListeningSessionState: Equatable {
    // nobody listening
    case idle
    // partner is listening
    case partnerListening(snapshot: PlaybackSnapshot)
    // listening alone
    case listeningAlone(snapshot: PlaybackSnapshot)
    // joining others' listening
    case joining(snapshot: PlaybackSnapshot)
    // already listening together
    case listeningTogether(snapshot: PlaybackSnapshot, sharedSince: Date)
    // reconnect
    case reconnecting(lastSnapshot: PlaybackSnapshot)
}
