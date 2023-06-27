//
//  AppleMusicSong.swift
//  Musily
//
//  Created by Lucas Flores on 26/06/23.
//

import Foundation
import MusicKit

struct AppleMusicSong: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageURL: URL?
    let musicURL: URL?
    let musicId : MusicItemID
}
