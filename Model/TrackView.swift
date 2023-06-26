//
//  TrackView.swift
//  Musily
//
//  Created by Isabela Bastos Jastrombek on 22/06/23.
//

import SwiftUI
import MusicKit
import MediaPlayer


struct TrackView: View {
    @ObservedObject var musicGetter = MusicGetter()
    
    var body: some View {
        if let musica = musicGetter.song {
            VStack(spacing: 24) {
                
                Spacer()
                
                Text("Recomendação do dia")
                    .font(.headline)
                    .foregroundColor(.white)
                
                AsyncImage(url: musica.artwork?.url(width: 300, height: 300))
                    .frame(width: 300, height: 300, alignment: .center)
                    .cornerRadius(16)
                
                VStack {
                    Text(musica.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(musica.artistName)
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                    
                    
                    Text("Placheholder do player")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                }
                
                
                Button {
                        playsSong(musica: musica)
                } label: {
                    HStack {
                        Group {
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                                .font(.title3)
                            
                            Text("Play")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        
                        
                    }
                    .padding()
                    .padding(.horizontal, 8)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("AccentColor1"), Color("AccentColor2")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(38)
                }
                
                Button {

                } label: {
                    HStack {
                        Group {
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                                .font(.title3)
                            
                            Text("Nova música")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        
                        
                    }
                    .padding()
                    .padding(.horizontal, 8)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("AccentColor1"), Color("AccentColor2")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(38)
                }
                
                Spacer()
                
                Image("ListenOnAppleMusic")
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 32)
            .background(Color("bkDarkColor"))
        } else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    func playsMusic(musica : Track) async {
        do{
//            let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: musica.musicId)
//            let response = try await request.response()
//            guard let song = response.items.first else { return }
            let player = ApplicationMusicPlayer.shared
            player.queue = [musica]
            try await player.prepareToPlay()
            try await player.play()
        } catch {
            error
            print(error)
        }
    }
    
    func playsSong (musica : Track) {
        Task {
            await playsMusic(musica: musica)
        }
    }
}
