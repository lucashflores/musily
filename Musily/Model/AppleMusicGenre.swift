//
//  AppleMusicGenre.swift
//  Musily
//
//  Created by Lucas Flores on 01/07/23.
//

import Foundation


struct GenreInfo: Hashable, Identifiable {
    var id = UUID()
    var genreName: String
    var genreInfo: String?
}
