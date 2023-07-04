//
//  TrackViewModel2.swift
//  Musily
//
//  Created by Tiago Mendes Bottamedi on 03/07/23.
//

import Foundation
import MusicKit
import UIKit
import SwiftUI


public class TrackViewModel2 {
    public var song: AppleMusicSong?
    public var albums: [AppleMusicAlbum]?
    public var image : UIImage?
//    public var bgColor = Color(.white)
    
    public init() {
    }
    
    public func fetchMusic() async {
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            do {
                
                let request = MusicCatalogResourceRequest<Playlist>(matching: \.id, equalTo: MusicItemID(rawValue: "pl.u-GgA5kl6coX9rGYW"))
                let plResponse = try await request.response()
                let playlist = plResponse.items.first
                let plWithTracks = try await playlist?.with([.tracks])
                let today = Date.now
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd"
                let day: Int = Int(dateFormatter.string(from: today)) ?? 1
                let songId = plWithTracks?.tracks?[day + 3].id
                let songRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: songId ?? MusicItemID(rawValue: ""))
                let songResponse = try await songRequest.response()
                let songWithArtists = try await songResponse.items.first?.with([.artists])
//                DispatchQueue.main.async {
                    let fetchedSong = songWithArtists.map({ song in
                        return AppleMusicSong(title: song.title, releaseDate: song.releaseDate, albumTitle: song.albumTitle , genreNames: song.genreNames.filter({ genre in
                            return genre != "Music"
                        }), artistName: song.artistName, composerName: song.composerName!, artistArtworkURL: (song.artwork?.url(width: 330, height: 330))!, albumArtworkURL: (song.artwork?.url(width: 169, height: 169))!, songURL: song.url!, musicKitSong: song)
                    })
                    guard let fetchedSong else { return }
                    self.song = fetchedSong
                    let data = try? Data(contentsOf: self.song!.albumArtworkURL)
                    print (String(describing: data))
                    self.image = UIImage(data: data!)
                
            } catch {
//                DispatchQueue.main.async {
                    self.song = AppleMusicSong.getDefault()
                    let data = try? Data(contentsOf: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/83/86/b4/8386b45a-4c4d-4fe7-90cc-d006df085de4/196589552242.jpg/300x300bb.jpg")!)
                    print (String(describing: data))
                    self.image = UIImage(data: data!)
                    self.albums = []
//                }
                print(error)
            }
        default:
            break
        }
    }
    
    
}
