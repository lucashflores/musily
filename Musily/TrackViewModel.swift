//
//  TrackViewModel.swift
//  Musily
//
//  Created by Lucas Flores on 30/06/23.
//

import Foundation
import MusicKit
import UIKit
import SwiftUI

class TrackViewModel: ObservableObject {
    @Published var song: AppleMusicSong?
    @Published var isLoading = false
    @Published var bgColor = Color("bkDarkColor")
    
    init() {
    }
    
    func fetchMusic()  {
        
        Task {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    
                    let request = MusicCatalogResourceRequest<Playlist>(matching: \.id, equalTo: MusicItemID(rawValue: "pl.ba2404fbc4464b8ba2d60399189cf24e"))
                    let plResponse = try await request.response()
                    let playlist = plResponse.items.first
                    let plWithTracks = try await playlist?.with([.tracks])
                    let today = Date.now
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd"
                    let day: Int = Int(dateFormatter.string(from: today)) ?? 1
                    let songId = plWithTracks?.tracks?[day - 1].id
                    let songRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: songId ?? MusicItemID(rawValue: ""))
                    let songResponse = try await songRequest.response()
                    let songWithArtists = try await songResponse.items.first?.with([.artists])
                    DispatchQueue.main.async {
                        
                        self.song = songWithArtists.map({ song in
                            return AppleMusicSong(title: song.title, albumTitle: song.albumTitle , genreNames: song.genreNames.filter({ genre in
                                return genre != "Music"
                            }), artistName: song.artistName, composerName: song.composerName!, artistArtworkURL: (song.artwork?.url(width: 330, height: 330))!, albumArtworkURL: (song.artwork?.url(width: 300, height: 300))!)
                        })
                        print(String(describing: self.song))
                        
                    }
                    break
                } catch {
                    print(error)
                }
            default:
                self.song = AppleMusicSong.getDefault()
                break
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func fetchCards() {
        Task {
            
        }
    }
    
    func getBackgroundColor() {
        let url = self.song?.albumArtworkURL
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        self.bgColor = Color(uiColor: image!.averageColor!)
    }
    
    func fetchAboutContent() { }
}
