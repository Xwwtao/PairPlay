//
//  PlaybackActionResolver.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/29.
//
import Foundation

enum PlaybackActionResolver{
    static func resolve(
        action: PlaybackAction,
        currentSnapshot: PlaybackSnapshot?,
        actor: String,
        now: Date
    )-> PlaybackSnapshot?{
        switch action{
        case .togglePlayPause:
            return resolveTogglePlayPause(
                currentSnapshot: currentSnapshot,
                actor: actor,
                now: now
            )
        case .seekBy(let offset):
            return resolveSeek(
                offset: offset,
                currentSnapshot: currentSnapshot,
                actor: actor,
                now: now
            )
            
        case .changeTrack(let newSnapshot):
            return resolveChangeTrack(
                newSnapshot: newSnapshot,
                currentSnapshot: currentSnapshot,
                actor: actor,
                now: now
            )
        }
    }
    
    private static func resolveTogglePlayPause(
        currentSnapshot: PlaybackSnapshot?,
        actor: String,
        now: Date
    ) -> PlaybackSnapshot? {
        guard let snapshot = currentSnapshot else {
            return nil
            
        }
        
        let currentPosition = PlaybackPositionCalculator.currentPosition(
            from: snapshot,
            now: now
        )
        
        return snapshot.copy(
            isPlaying: !snapshot.isPlaying,
            positionSeconds: currentPosition,
            sequence: snapshot.sequence + 1,
            updatedBy: actor,
            serverTimestamp: now
            
        )
    }
        
    private static func resolveSeek(
        offset: Double,
        currentSnapshot: PlaybackSnapshot?,
        actor: String,
        now: Date
        ) -> PlaybackSnapshot? {
            guard let snapshot = currentSnapshot else {
                return nil
            }
            
            let currentPosition = PlaybackPositionCalculator.currentPosition(
                from: snapshot,
                now: now
            )
            
            let newPosition = min(
                max(currentPosition + offset, 0),
                snapshot.durationSeconds
            )
            
            return snapshot.copy(
                positionSeconds: newPosition,
                sequence: snapshot.sequence + 1,
                updatedBy: actor,
                serverTimestamp: now
            )
        }
        
        private static func resolveChangeTrack(
            newSnapshot: PlaybackSnapshot,
            currentSnapshot: PlaybackSnapshot?,
            actor: String,
            now: Date
        ) -> PlaybackSnapshot {
            let nextSequence = (currentSnapshot?.sequence ?? 0) + 1
            return newSnapshot.copy(
                isPlaying: true,
                positionSeconds: 0,
                sequence: nextSequence,
                updatedBy: actor,
                serverTimestamp: now
            )
    }
}
