//
//  LastFMGenre.swift
//  Musily
//
//  Created by Lucas Flores on 02/07/23.
//

import Foundation


struct LastFMTag: Codable {
    var wiki: LastFMWiki
}

struct LastFMTagResponse: Codable {
    var tag: LastFMTag
}
