//
//  PlaybackAction.swift
//  PairPlay
//
//  Created by Wentao Xie on 2026/4/29.
//

import Foundation

enum PlaybackAction{
    case togglePlayPause
    case seekBy(Double)
    case changeTrack(PlaybackSnapshot)
}
