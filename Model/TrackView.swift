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
    @State var imagem = "play.fill"
    let player = ApplicationMusicPlayer.shared
    
    var body: some View {
        if let musica = musicGetter.song {
            VStack(spacing: 24) {
                
                Spacer()
                
                Text("Recomendação do dia")
                    .font(.headline)
                    .foregroundColor(.white)
                
                AsyncImage(url: musica.artists?.first?.artwork?.url(width: 300, height: 300))
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
                    
                }
                
                
                Button {
                    if player.state.playbackStatus == .playing {
                        imagem = "play.fill"
                        player.pause()

                    } else {
                        imagem = "pause.fill"
                        if player.queue.entries.isEmpty {
                            playsSong(musica: musica)
                        }
                        else {
                            resumeSong()
                        }
                    }
                } label: {
                    Image (systemName: imagem)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
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
    
    func playsMusic(musica : Song) async {
        do{ 
            player.queue = [musica]
            try await player.prepareToPlay()
            try await player.play()
        } catch {
            error
            print(error)
        }
    }
    
    func resumeSong() {
        Task {
            do {
                try await player.play()
            }
            catch {
                
            }
        }
    }
    
    func playsSong (musica : Song) {
        Task {
            await playsMusic(musica: musica)
        }
    }
}
