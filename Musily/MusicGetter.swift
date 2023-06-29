//
//  MusicGetter.swift
//  Musily
//
//  Created by Tiago Mendes Bottamedi on 22/06/23.
//

import Foundation
import MusicKit


class MusicGetter: ObservableObject {
    @Published var song : Song?
    var test = ""

    
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
                    let songId = plWithTracks?.tracks?[day - 1].id
                    let songRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: songId ?? MusicItemID(rawValue: ""))
                    let songResponse = try await songRequest.response()
                    let songWithArtists = try await songResponse.items.first?.with([.artists])
                    DispatchQueue.main.async {
                        self.song = songWithArtists
                    }
                    
                    
                    await NetworkManager.shared.askChatGPT(prompt: "Me fale sobre o gênero de música rap em no máximo 50 palavras") {
                        [weak self] result in
                        switch result {
                        case .success(let answer):
//                            self.test = answer
                            print(answer)
                            break
                        case .failure(let error):
                            print(error)
                            break
                        }
                    }
                } catch {
                    print(error)
                }
            default:
                break
            }
        }
    }
    
}
