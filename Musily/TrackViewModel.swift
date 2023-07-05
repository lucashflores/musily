import Foundation
import MusicKit
import UIKit
import SwiftUI


public class TrackViewModel: ObservableObject {
    @Published public var song: AppleMusicSong?
    @Published public var albums: [AppleMusicAlbum]?
    @Published public var isSongLoading = false
    @Published public var bgColor = Color(.white)
    @Published public var artistInfo: String?
    @Published public var albumInfo: String?
    @Published public var trackInfo: String?
    @Published public var allGenreInformation: [GenreInfo]?
    
    
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
                let songId = plWithTracks?.tracks?[day - 1].id
                let songRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: songId ?? MusicItemID(rawValue: ""))
                let songResponse = try await songRequest.response()
                let songWithArtists = try await songResponse.items.first?.with([.artists])
                let fetchedSong = songWithArtists.map({ song in
                    return AppleMusicSong(title: song.title, releaseDate: song.releaseDate, albumTitle: song.albumTitle , genreNames: song.genreNames.filter { $0 != "Music" }.flatMap {
                        $0.components(separatedBy: "/")
                    }, artistName: song.artistName, composerName: song.composerName ?? "Unavailable", artistArtworkURL: (song.artwork?.url(width: 350, height: 350))!, albumArtworkURL: (song.artwork?.url(width: 300, height: 300))!, songURL: song.url!, musicKitSong: song)
                })
                guard let fetchedSong else { return }
                let data = try? Data(contentsOf: fetchedSong.albumArtworkURL)
                let image = UIImage(data: data!)
                let artistId = songWithArtists?.artists?.first?.id
                let artistRequest = MusicCatalogResourceRequest<Artist>(matching: \.id, equalTo: artistId ?? MusicItemID(rawValue: ""))
                let artistResponse = try await artistRequest.response()
                let artistWithAlbums = try await artistResponse.items.first?.with([.albums])
                guard let albums = artistWithAlbums?.albums else { return }
                DispatchQueue.main.async {
                    self.song = fetchedSong
                    self.bgColor = Color(uiColor: image!.averageColor!)
                    self.albums = albums.filter({ album in
                        return album.title != self.song?.albumTitle && album.isSingle == false
                    }).map({ album in
                        return AppleMusicAlbum(title: album.title, artworkURL: album.artwork?.url(width: 240, height: 240), albumURL: album.url)
                    })
                }


                
            } catch {
                DispatchQueue.main.async {
                    self.song = AppleMusicSong.getDefault()
                    self.albums = []
                }
                print(error)
            }
        default:
            break
        }
    }
    
    public func fetchInfo(trackTitle: String, artistName: String, albumTitle: String, genreNames: [String]) {
        
        func addDotAtTheEnd(info: String) -> String {
            if (info.last != "." && info.count > 0) {
                return info + "."
            }
            return info
        }
        
        
        NetworkManager.shared.getArtistInfo(artistName: artistName) {
            result in
            switch result {
            case (.success(let artistResponse)):
                let artistInfoResponse = artistResponse.artist.bio.content
        
                DispatchQueue.main.async {
                    if (artistInfoResponse.replacingOccurrences(of: " ", with: " ").count == 0)
                    {
                        self.artistInfo = "Unavailable"
                    }
                    else{
                        self.artistInfo = addDotAtTheEnd(info: artistInfoResponse.replacingOccurrences(of: " <a(.*)", with: "", options: .regularExpression))
                    }

        
                }
            case(.failure(let error)):
                print("artist")
                print(error)
            }
        }
        
        NetworkManager.shared.getTrackInfo(artistName: artistName, trackTitle: trackTitle) {
            result in
            switch result {
            case (.success(let trackResponse)):
                DispatchQueue.main.async {
                    let trackInfoResponse = trackResponse.track.wiki.content
                    if (trackInfoResponse.replacingOccurrences(of: " ", with: " ").count == 0)
                    {
                        self.trackInfo = "Unavailable"
                    }
                    else {
                        self.trackInfo = addDotAtTheEnd(info: trackInfoResponse.replacingOccurrences(of: " <a(.*)", with: "", options: .regularExpression))
                    }
                    
                }
            case(.failure(let error)):
                print("track")
                print(error)
                DispatchQueue.main.async {
                    self.trackInfo = "Unavailable"
                }
            }
        }
        
        NetworkManager.shared.getAlbumInfo(artistName: artistName, albumTitle: albumTitle) {
            result in
            switch result {
            case (.success(let albumResponse)):
                DispatchQueue.main.async {
                    let albumInfoResponse = albumResponse.album.wiki.content
                    print(albumInfoResponse)
                    if (albumInfoResponse.replacingOccurrences(of: " ", with: " ").count == 0)
                    {
                        self.albumInfo = "Unavailable"
                    }
                    else {
                        self.albumInfo = addDotAtTheEnd(info: albumInfoResponse.replacingOccurrences(of: " <a(.*)", with: "", options: .regularExpression))
                    }
                }
            case(.failure(let error)):
                print("album")
                print(error)
                DispatchQueue.main.async {
                    self.albumInfo = "Unavailable"
                }
            }
        }
        print(genreNames)
        for genreName in genreNames {
            NetworkManager.shared.getGenreInfo(genre: genreName.replacingOccurrences(of: "-", with: "")) {
                result in
                
                switch result {
                case (.success(let genreResponse)):
                    if (self.allGenreInformation == nil) {
                        DispatchQueue.main.async {
                            self.allGenreInformation = []
                        }
                    }
                    DispatchQueue.main.async {
                        let genreInfoResponse = genreResponse.tag.wiki.content
                        if (genreInfoResponse.replacingOccurrences(of: " ", with: " ").count > 0) {
                            print(genreInfoResponse)
                            self.allGenreInformation?.append(GenreInfo(genreName: genreName, genreInfo: addDotAtTheEnd(info: genreInfoResponse.replacingOccurrences(of: " <a(.*)", with: "", options: .regularExpression))))
                        }
                        else {
                            self.allGenreInformation?.append(GenreInfo(genreName: genreName, genreInfo: "Unavailable"))
                        }
                    }
                case(.failure(let error)):
                    
                    print(error)
                }
            }
        }
    }
    
    public func fetchContent() {
        Task {
            await self.fetchMusic()
            guard let song = self.song else { return }
            self.fetchInfo(trackTitle: song.title ?? "unavailable", artistName: song.artistName ?? "unavailable", albumTitle: song.albumTitle ?? "unavailable", genreNames: song.genreNames
            )
        }
    }
}
