import Foundation
import MusicKit

public struct AppleMusicSong: Identifiable, Hashable {
    public init(id: UUID = UUID(), title: String? = nil, releaseDate: Date? = nil, albumTitle: String? = nil, genreNames: [String], artistName: String? = nil, composerName: String? = nil, artistArtworkURL: URL, albumArtworkURL: URL, songURL: URL, musicKitSong: Song? = nil) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.albumTitle = albumTitle
        self.genreNames = genreNames
        self.artistName = artistName
        self.composerName = composerName
        self.artistArtworkURL = artistArtworkURL
        self.albumArtworkURL = albumArtworkURL
        self.songURL = songURL
        self.musicKitSong = musicKitSong
    }
    
    public var id = UUID()
    public var title: String?
    public var releaseDate: Date?
    public var albumTitle: String?
    public var genreNames: [String]
    public var artistName: String?
    public var composerName: String?
    public var artistArtworkURL: URL
    public var albumArtworkURL: URL
    public var songURL: URL
    public var musicKitSong: Song?
    
    public static func getDefault() -> AppleMusicSong {
        return AppleMusicSong(title: "Shirt", releaseDate: Date(timeIntervalSince1970: 1640995200), albumTitle: "Shirt - Single", genreNames: ["R&B/Soul"], artistName: "SZA", composerName: "SZA, Rodney Jerkins & Rob Gueringer", artistArtworkURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages122/v4/46/c9/ef/46c9ef75-1117-115c-ed16-e467e80e78a5/f22dc859-693e-42dd-aa72-00a513b03c00_file_cropped.png/330x330bb.jpg")!, albumArtworkURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/83/86/b4/8386b45a-4c4d-4fe7-90cc-d006df085de4/196589552242.jpg/300x300bb.jpg")!, songURL: URL(string: "https://music.apple.com/br/album/shirt/1648735510?i=1648735704s")!, musicKitSong: nil)
    }
}
