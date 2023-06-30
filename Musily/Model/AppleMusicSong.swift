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
    var title: String?
    var albumTitle: String?
    var genreNames: [String]
    var artistName: String?
    var composerName: String?
    var artistArtworkURL: URL
    var albumArtworkURL: URL
    var musicKitSong: Song?
    
    static func getDefault() -> AppleMusicSong {
        return AppleMusicSong(title: "Shirt", albumTitle: "Shirt - Single", genreNames: ["R&B/Soul"], artistName: "SZA", composerName: "SZA, Rodney Jerkins & Rob Gueringer", artistArtworkURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages122/v4/46/c9/ef/46c9ef75-1117-115c-ed16-e467e80e78a5/f22dc859-693e-42dd-aa72-00a513b03c00_file_cropped.png/330x330bb.jpg")!, albumArtworkURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/83/86/b4/8386b45a-4c4d-4fe7-90cc-d006df085de4/196589552242.jpg/300x300bb.jpg")!, musicKitSong: nil)
    }
}
