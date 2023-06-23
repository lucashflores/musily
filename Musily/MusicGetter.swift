//
//  MusicGetter.swift
//  Musily
//
//  Created by Tiago Mendes Bottamedi on 22/06/23.
//

import Foundation
import MusicKit

struct Item: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageURL: URL?
    let musicURL: URL?
    let musicId : MusicItemID
}

class MusicGetter: ObservableObject {
    private var songs = [Item]()
    @Published var song : Item?
    private let request: MusicCatalogSearchRequest = {
        var request = MusicCatalogSearchRequest(term: "Happy", types: [Song.self])
        request.limit = 25
        return request
    }()
    
    init() {
        fetchMusic()
    }
    
    private func fetchMusic() {
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let result = try await request.response()
                    self.songs = result.songs.compactMap({ return .init(name: $0.title, artist: $0.artistName, imageURL:$0.artwork?.url(width: 300, height: 300), musicURL: $0.url, musicId: $0.id)})
                    song = songs.randomElement()
                } catch {
                    error
                    print(error)
                }
            default:
                break
            }
        }
    }
    
}
