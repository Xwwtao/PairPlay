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
    
    private var timer: Timer?
    
    init() {
        startTimer()
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
    
    func togglePlayPause() {
        guard let snapshot = currentSnapshot else {
            return
        }

        let currentPosition = PlaybackPositionCalculator.currentPosition(
            from: snapshot,
            now: now
        )

        let updatedSnapshot = snapshot.copy(
            isPlaying: !snapshot.isPlaying,
            positionSeconds: currentPosition,
            sequence: snapshot.sequence + 1,
            updatedBy: "me",
            serverTimestamp: Date()
        )

        updateSessionWithNewSnapshot(updatedSnapshot)
    }

    func seekForward15() {
        seek(by: 15)
    }

    func seekBackward15() {
        seek(by: -15)
    }

    private func seek(by offset: Double) {
        guard let snapshot = currentSnapshot else {
            return
        }

        let currentPosition = PlaybackPositionCalculator.currentPosition(
            from: snapshot,
            now: now
        )

        let newPosition = min(
            max(currentPosition + offset, 0),
            snapshot.durationSeconds
        )

        let updatedSnapshot = snapshot.copy(
            positionSeconds: newPosition,
            sequence: snapshot.sequence + 1,
            updatedBy: "me",
            serverTimestamp: Date()
        )

        updateSessionWithNewSnapshot(updatedSnapshot)
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

    private func updateSessionWithNewSnapshot(_ snapshot: PlaybackSnapshot) {
        switch sessionState {
        case .listeningTogether(_, let sharedSince):
            sessionState = .listeningTogether(
                snapshot: snapshot,
                sharedSince: sharedSince
            )

        case .listeningAlone:
            sessionState = .listeningAlone(snapshot: snapshot)

        case .partnerListening:
            sessionState = .partnerListening(snapshot: snapshot)

        case .joining:
            sessionState = .joining(snapshot: snapshot)

        case .idle:
            sessionState = .listeningAlone(snapshot: snapshot)

        case .reconnecting:
            sessionState = .reconnecting(lastSnapshot: snapshot)
        }
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
