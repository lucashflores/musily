//
//  LastFMAlbumResponse.swift
//  Musily
//
//  Created by Lucas Flores on 02/07/23.
//

import Foundation



struct LastFMALbum: Codable {
    var wiki: LastFMWiki
}

struct LastFMAlbumResponse: Codable {
    var album: LastFMALbum
}
