//
//  AppleMusicGenre.swift
//  Musily
//
//  Created by Lucas Flores on 01/07/23.
//

import Foundation


public struct GenreInfo: Hashable, Identifiable {
    public var id = UUID()
    public var genreName: String
    public var genreInfo: String?
}
