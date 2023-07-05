//
//  LastFMArtist.swift
//  Musily
//
//  Created by Lucas Flores on 02/07/23.
//

import Foundation

struct LastFMBio: Codable {
    var summary: String
    var content: String
}

struct LastFMArtist: Codable {
    var name: String
    var bio: LastFMBio
    
}

struct LastFMArtistResponse: NetworkResponse {
    var artist: LastFMArtist
}
