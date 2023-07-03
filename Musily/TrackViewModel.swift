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
        fetchContent()
    }
    
    
    public func fetchMusic() async {
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            do {
                
                let request = MusicCatalogResourceRequest<Playlist>(matching: \.id, equalTo: MusicItemID(rawValue: "pl.ce25c7c7bd30485ea94e3bd5a91a1e94"))
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
                    return AppleMusicSong(title: song.title, releaseDate: song.releaseDate, albumTitle: song.albumTitle , genreNames: song.genreNames.filter({ genre in
                        return genre != "Music"
                    }), artistName: song.artistName, composerName: song.composerName ?? "Unavailable", artistArtworkURL: (song.artwork?.url(width: 330, height: 330))!, albumArtworkURL: (song.artwork?.url(width: 300, height: 300))!, songURL: song.url!, musicKitSong: song)
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
            if (info.last != ".") {
                return info + "."
            }
            return info
        }
        
        
        NetworkManager.shared.getArtistInfo(artistName: artistName) {
            result in
            switch result {
            case (.success(let artistResponse)):
                DispatchQueue.main.async {
                    self.artistInfo = addDotAtTheEnd(info: artistResponse.artist.bio.summary.replacingOccurrences(of: " <a(.*)", with: "", options: .regularExpression))
                    
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
                    self.trackInfo = addDotAtTheEnd(info: trackResponse.track.wiki.summary.replacingOccurrences(of: " <a(.*)", with: "", options: .regularExpression))
                    
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
                    self.albumInfo = addDotAtTheEnd(info: albumResponse.album.wiki.summary.replacingOccurrences(of: " <a(.*)", with: "", options: .regularExpression))
                }
            case(.failure(let error)):
                print("album")
                print(error)
                DispatchQueue.main.async {
                    self.albumInfo = "Unavailable"
                }
            }
        }
        
        for genreName in genreNames {
            NetworkManager.shared.getGenreInfo(genre: genreName) {
                result in
                switch result {
                case (.success(let genreResponse)):
                    if (self.allGenreInformation == nil) {
                        DispatchQueue.main.async {
                            self.allGenreInformation = []
                        }
                    }
                    DispatchQueue.main.async {
                        self.allGenreInformation?.append(GenreInfo(genreName: genreName, genreInfo: addDotAtTheEnd(info: genreResponse.tag.wiki.summary.replacingOccurrences(of: " <a(.*)", with: "", options: .regularExpression))))
                        
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
