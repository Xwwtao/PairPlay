//
//  MusicEnvironmentService.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/5/1.
//

import Foundation

protocol MusicEnvironmentService {
    func currentAppleMusicState() async -> AppleMusicState
}

struct MockMusicEnvironmentService: MusicEnvironmentService {
    var state: AppleMusicState = .mockReady

    func currentAppleMusicState() async -> AppleMusicState {
        state
    }
}
