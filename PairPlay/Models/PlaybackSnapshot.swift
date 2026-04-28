//
//  PlaybackSnapshot.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//
//  This model shows which song user is listening and where it played

import Foundation

struct PlaybackSnapshot: Equatable {
    let trackId: String
    let title: String
    let artist: String
    let isPlaying: Bool
    let positionSeconds: Double
    let durationSeconds: Double
    let sequence: Int
    let updatedBy: String
    let serverTimestamp: Date
    
    static let sample = PlaybackSnapshot(
        trackId: "sample_track_001",
        title: "Counting Stars",
        artist: "OneRepublic",
        isPlaying: true,
        positionSeconds: 84,
        durationSeconds: 228,
        sequence: 1,
        updatedBy: "partner",
        serverTimestamp: Date()
    )
}
