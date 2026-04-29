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
    
    static func sample(
        title: String = "Wanted",
        artist: String = "OneRepublic",
        positionSeconds: Double = 84,
        isPlaying: Bool = true,
        sequence: Int = 1,
        updatedBy: String = "partner"
    ) -> PlaybackSnapshot {
        PlaybackSnapshot(
            trackId: "sample_track_001",
            title: title,
            artist: artist,
            isPlaying: isPlaying,
            positionSeconds: positionSeconds,
            durationSeconds: 228,
            sequence: sequence,
            updatedBy: updatedBy,
            serverTimestamp: Date()
        )
    }
    
    func copy(
        trackId: String? = nil,
        title: String? = nil,
        artist: String? = nil,
        isPlaying: Bool? = nil,
        positionSeconds: Double? = nil,
        durationSeconds: Double? = nil,
        sequence: Int? = nil,
        updatedBy: String? = nil,
        serverTimestamp: Date? = nil
    ) -> PlaybackSnapshot {
        PlaybackSnapshot(
            trackId: trackId ?? self.trackId,
            title: title ?? self.title,
            artist: artist ?? self.artist,
            isPlaying: isPlaying ?? self.isPlaying,
            positionSeconds: positionSeconds ?? self.positionSeconds,
            durationSeconds: durationSeconds ?? self.durationSeconds,
            sequence: sequence ?? self.sequence,
            updatedBy: updatedBy ?? self.updatedBy,
            serverTimestamp: serverTimestamp ?? self.serverTimestamp
        )
    }
}
