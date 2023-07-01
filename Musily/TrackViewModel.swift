import Foundation
import MusicKit
import UIKit
import SwiftUI

class TrackViewModel: ObservableObject {
    @Published var song: AppleMusicSong?
    @Published var albums: [AppleMusicAlbum]?
    @Published var isSongLoading = false
    @Published var bgColor = Color("bkDarkColor")
    @Published var artistInfo: String?
    @Published var albumInfo: String?
    @Published var allGenreInformation: [GenreInfo]?
    
    
    init() {
    }
    
    private func fetchMusic() async {
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
                    let fetchedSong = songWithArtists.map({ song in
                        return AppleMusicSong(title: song.title, releaseDate: song.releaseDate, albumTitle: song.albumTitle , genreNames: song.genreNames.filter({ genre in
                            return genre != "Music"
                        }), artistName: song.artistName, composerName: song.composerName!, artistArtworkURL: (song.artwork?.url(width: 330, height: 330))!, albumArtworkURL: (song.artwork?.url(width: 300, height: 300))!, songURL: song.url!)
                    })
                    guard let fetchedSong else { return }
                    self.song = fetchedSong
                    let data = try? Data(contentsOf: self.song!.albumArtworkURL)
                    let image = UIImage(data: data!)
                    self.bgColor = Color(uiColor: image!.averageColor!)
                }
                let artistId = songWithArtists?.artists?.first?.id
                let artistRequest = MusicCatalogResourceRequest<Artist>(matching: \.id, equalTo: artistId ?? MusicItemID(rawValue: ""))
                let artistResponse = try await artistRequest.response()
                let artistWithAlbums = try await artistResponse.items.first?.with([.albums])
                DispatchQueue.main.async {
                    guard let albums = artistWithAlbums?.albums else { return }
                    self.albums = albums.filter({ album in
                        return album.title != self.song?.albumTitle && album.isSingle == false
                    }).map({ album in
                        return AppleMusicAlbum(title: album.title, artworkURL: album.artwork?.url(width: 240, height: 240))
                    })
                }

                
            } catch {
                print(error)
            }
        default:
            break
        }
    }
    
    private func fetchInfo(artistName: String, albumTitle: String, genreNames: [String]) async {
        let maxWordNumber = 40
        if (artistName != "unavailable")
        {
            await NetworkManager.shared.askChatGPT(prompt: "me fale sobre o artista \(artistName) em no máximo 75 palavras") { result in
                switch result {
                case .success(let answer):
                    DispatchQueue.main.async {
                        self.artistInfo = self.formatAnswer(answer: answer)
                    }
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            
            if (albumTitle != "unavailable") {
                await NetworkManager.shared.askChatGPT(prompt: "me fale sobre o álbum \(albumTitle) de \(artistName) em no máximo \(maxWordNumber) palavras") { result in
                    switch result {
                    case .success(let answer):
                        DispatchQueue.main.async {
                            self.albumInfo = self.formatAnswer(answer: answer)
                        }
                    case .failure(let error):
                        print(String(describing: error))
                    }
                }
            }
        }
        for genreName in genreNames {
            if (genreName != "unavailable")
            {
                await NetworkManager.shared.askChatGPT(prompt: "me fale sobre o gênero de música \(genreName) em no máximo \(maxWordNumber) palavras") { result in
                    switch result {
                    case .success(let answer):
                        DispatchQueue.main.async {
                            if (self.allGenreInformation == nil) {
                                self.allGenreInformation = []
                            }
                            self.allGenreInformation!.append(GenreInfo(genreName: genreName, genreInfo: answer))
                        }
                    case .failure(let error):
                        print(String(describing: error))
                    }
                }
            }
        }
        
    }
    
    func formatAnswer(answer: String) -> String {
        if (answer != "Nenhuma informação.") {
            return answer.replacingOccurrences(of: " Nenhuma informação.", with: "")
        }
        return answer
    }
    
    func fetchContent() {
        Task {
            await self.fetchMusic()
            while (self.song == nil){
            }
            await fetchInfo(artistName: song?.artistName ?? "unavailable", albumTitle: song?.albumTitle ?? "unavailable", genreNames: song?.genreNames ?? [])
        }
    }
}
