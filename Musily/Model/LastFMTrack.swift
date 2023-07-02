//
//  LastFMTrack.swift
//  Musily
//
//  Created by Lucas Flores on 02/07/23.
//

import Foundation

struct LastFMTrack: Codable {
    var wiki: LastFMWiki
}

struct LastFMTrackResponse: Codable {
    var track: LastFMTrack
}
