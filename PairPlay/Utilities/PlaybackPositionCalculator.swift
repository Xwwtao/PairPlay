//
//  PlaybackPositionCalculator.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//
import Foundation

enum PlaybackPositionCalculator{
    static func currentPosition(
        from snapshot: PlaybackSnapshot,
        now: Date
    ) -> Double{
        guard snapshot.isPlaying else{
            return clamped(
                snapshot.positionSeconds,
                min: 0,
                max: snapshot.durationSeconds
            )
        }
        let elapsed = now.timeIntervalSince(snapshot.serverTimestamp)
        let estimatedPosition = snapshot.positionSeconds + elapsed
        
        return clamped(
            estimatedPosition,
            min: 0,
            max: snapshot.durationSeconds
        )
    }
    
    static func progress(
        from snapshot: PlaybackSnapshot,
        now:Date
    )-> Double{
        let current = currentPosition(from: snapshot, now: now)
        guard snapshot.durationSeconds > 0 else{
            return 0
        }
        
        return current / snapshot.durationSeconds
    }
    
    private static func clamped(
        _ value: Double,
        min lowerBound: Double,
        max upperBound: Double
    ) -> Double{
        Swift.min(Swift.max(value, lowerBound), upperBound)
    }
}
