//
//  HomeViewModel.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/28.
//

import Foundation
internal import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var sessionState: ListeningSessionState = .partnerListening(snapshot: .sample())
    @Published var now: Date = Date()
    @Published var environmentState: AppEnvironmentState = .mockReady
    
    private let musicEnvironmentService: MusicEnvironmentService
    private let playbackSyncService: PlaybackSyncService
    private var timer: Timer?
    
    init(
        musicEnvironmentService: MusicEnvironmentService? = nil,
        playbackSyncService: PlaybackSyncService? = nil
    ) {
        self.musicEnvironmentService = musicEnvironmentService ?? MockMusicEnvironmentService()
        self.playbackSyncService = playbackSyncService ?? MockPlaybackSyncService()
        startTimer()
        startPlaybackSync()
        refreshAppleMusicState()
    }
    
    deinit{
        timer?.invalidate()
    }
    
    func simulatePartnerNotListening(){
        sessionState = .idle
    }
    
    func simulatePartnerListening(){
        sessionState = .partnerListening(snapshot: .sample())
    }
    
    func joinListening(){
        guard case let .partnerListening(snapshot) = sessionState else{
            return
        }
        
        sessionState = .joining(snapshot: snapshot)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
            self.sessionState = .listeningTogether(
                snapshot: snapshot,
                sharedSince: Date()
            )
        }
    }
    
    func openPlayer(){
        
    }
    
    
    func leaveSession() {
        sessionState = .partnerListening(snapshot: .sample())
    }
    
    func performLocalAction(_ action: PlaybackAction) {
        let currentSnapshot = SyncReducer.currentSnapshot(from: sessionState)

        guard let updatedSnapshot = PlaybackActionResolver.resolve(
            action: action,
            currentSnapshot: currentSnapshot,
            actor: "me",
            now: now
        ) else {
            return
        }

        sessionState = SyncReducer.applyLocalSnapshot(
            updatedSnapshot,
            to: sessionState
        )

        sendSnapshotToSyncService(updatedSnapshot)
    }

    func performRemoteAction(_ action: PlaybackAction) {
        let currentSnapshot = SyncReducer.currentSnapshot(from: sessionState)

        guard let remoteSnapshot = PlaybackActionResolver.resolve(
            action: action,
            currentSnapshot: currentSnapshot,
            actor: "partner",
            now: now
        ) else {
            return
        }

        simulateIncomingRemoteSnapshot(remoteSnapshot)
    }
    
    func togglePlayPause() {
        performLocalAction(.togglePlayPause)
    }

    func seekForward15() {
        performLocalAction(.seekBy(15))
    }

    func seekBackward15() {
        performLocalAction(.seekBy(-15))
    }
    
    func simulatePartnerTogglePlayPause() {
        performRemoteAction(.togglePlayPause)
    }

    func simulatePartnerSeekForward15() {
        performRemoteAction(.seekBy(15))
    }

    func simulatePartnerSeekBackward15() {
        performRemoteAction(.seekBy(-15))
    }

    func simulatePartnerChangeSong() {
        let currentSnapshot = SyncReducer.currentSnapshot(from: sessionState)
        let nextTrack: PlaybackSnapshot
            if currentSnapshot?.trackId == "sample_track_002" {
                nextTrack = PlaybackSnapshot.sampleTrackThree(
                    sequence: 0,
                    updatedBy: "partner"
                )
            } else {
                nextTrack = PlaybackSnapshot.sampleTrackTwo(
                    sequence: 0,
                    updatedBy: "partner"
                )
            }
            performRemoteAction(.changeTrack(nextTrack))
    }

    func simulateOldRemoteEvent() {
        guard let snapshot = SyncReducer.currentSnapshot(from:sessionState) else {
            return
        }

        let oldSnapshot = snapshot.copy(
            isPlaying: false,
            positionSeconds: 10,
            sequence: max(0, snapshot.sequence - 1),
            updatedBy: "partner",
            serverTimestamp: Date()
        )

        applyRemoteSnapshot(oldSnapshot)
    }
    
    func toggleQuietMode() {
        environmentState.quietModeEnabled.toggle()
    }

    func simulateConnectionIssue() {
        guard let snapshot = SyncReducer.currentSnapshot(from: sessionState) else { return }
        environmentState.connectionState = .reconnecting
        sessionState = .reconnecting(lastSnapshot: snapshot)
    }

    func simulateConnectionRestored() {
        environmentState.connectionState = .connected

        if case let .reconnecting(lastSnapshot) = sessionState {
            sessionState = .partnerListening(snapshot: lastSnapshot)
        } else {
            sessionState = .idle
        }
    }

    func simulateAppleMusicDenied() {
        environmentState.appleMusicState = AppleMusicState(
            authorization: .denied,
            subscription: .unknown
        )
    }

    func simulateAppleMusicReady() {
        environmentState.appleMusicState = .mockReady
    }

    func refreshAppleMusicState() {
        Task {
            let state = await musicEnvironmentService.currentAppleMusicState()
            environmentState.appleMusicState = state
        }
    }

    private func applyRemoteSnapshot(_ remoteSnapshot: PlaybackSnapshot) {
        sessionState = SyncReducer.applySnapshot(
            remoteSnapshot,
            to: sessionState
        )
    }

    private func startPlaybackSync() {
        playbackSyncService.startListening { [weak self] snapshot in
            self?.applyRemoteSnapshot(snapshot)
        }
    }

    private func sendSnapshotToSyncService(_ snapshot: PlaybackSnapshot) {
        Task {
            await playbackSyncService.sendSnapshot(snapshot)
        }
    }

    private func simulateIncomingRemoteSnapshot(_ snapshot: PlaybackSnapshot) {
        guard let debugSyncService = playbackSyncService as? DebugPlaybackSyncService else {
            applyRemoteSnapshot(snapshot)
            return
        }

        debugSyncService.simulateIncomingSnapshot(snapshot)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.now = Date()
            }
        }
    }
}
