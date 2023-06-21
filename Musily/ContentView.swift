//
//  ContentView.swift
//  Musily
//
//  Created by Lucas Flores on 21/06/23.
//

import SwiftUI
import MusicKit

struct Item: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageURL: URL?
}

struct ContentView: View {
    @State var songs = [Item]()
    
    var body: some View {
        VStack {
            List(songs) { song in
                HStack {
                    AsyncImage(url: song.imageURL)
                        .frame(width: 75, height: 75, alignment: .center)
                    VStack(alignment: .leading) {
                        Text(song.name).font(.title3)
                        Text(song.artist)
                            .font(.footnote)
                    }
                }
            }
        }
        .onAppear(perform: fetchMusic)
        .padding()
    }
    
    private let request: MusicCatalogSearchRequest = {
        var request = MusicCatalogSearchRequest(term: "Happy", types: [Song.self])
        request.limit = 25
        return request
    }()
    
    private func fetchMusic() {
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let result = try await request.response()
                    self.songs = result.songs.compactMap({ return .init(name: $0.title, artist: $0.artistName, imageURL:$0.artwork?.url(width: 75, height: 75))})
                } catch {
                    
                }
            default:
                break
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
