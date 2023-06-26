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
    @Published var song : Track?

    
    init() {
        fetchMusic()
    }
    
    private func fetchMusic() {
        Task {
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
                    self.song = plWithTracks?.tracks?[day - 1]
                } catch {
                    print(error)
                }
            default:
                break
            }
        }
    }
    
}
