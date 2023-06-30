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
    var cards: [MediaInformationCard]?
    private var player = AppleMusicPlayer()
    @ObservedObject private var viewModel: TrackViewModel = TrackViewModel()
    @State var imagem = "play.circle.fill"
    @State var share = "square.and.arrow.up"
    @State var bgColor = Color("bkDarkColor")
    
    
    var body: some View {
        ZStack { 
            if (viewModel.isLoading) {
                ProgressView().progressViewStyle(.circular)
            }
            else if let music = viewModel.song {
            
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(Color(uiColor: .clear))
                        .overlay {
                            LinearGradient(
                                colors: [.white, Color(uiColor: .clear), .black],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                        }
                        .opacity(0.3)
                }
                
                ScrollView {
                    VStack {
                        VStack(spacing: 24) {
                            
                            Spacer()
                            
                            HStack(spacing: 0) {
                                Group {
                                    Text("Discover")
                                        .font(.title3)
                                        .fontWeight(.black)
                                    
                                    Text(" of the day")
                                        .font(.title3)
                                }
                                .foregroundColor(.white)
                            }
                            
                            AsyncImage(url: music.artistArtworkURL)
                                .frame(width: 330, height: 330, alignment: .center)
                                .cornerRadius(16)
                            
                                
                            
                            HStack{
                                VStack(spacing: 0) {
                                    Text(music.title ?? "Indisponível")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text(music.artistName ?? "Indisponível")
                                        .font(.headline)
                                        .fontWeight(.light)
                                        .foregroundColor(.white)

                                }
                                Spacer()
                            }
                            
                            
                            HStack {

                                Button {
                                    if player.getPlaybackStatus() == .playing {
                                        imagem = "play.circle.fill"
                                        player.pause()

                                    } else {
                                        if let musicKitSong = music.musicKitSong {
                                            imagem = "pause.circle.fill"
                                            if player.isPlayerQueueEmpty() {
                                                player.playsSong(musica: musicKitSong)
                                            }
                                            else {
                                                player.resumeSong()
                                            }
                                        } else {
                                            
                                        }
                                    }
                                }
                                
                                
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: .infinity, height: 3)
                                    .padding(.horizontal, 8)
                                    .cornerRadius(24)
                                
                                Spacer()
                                
                                Text("-2:20")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(music.genreNames, id: \.self){ genre in
                                        GenreView (text: genre)
                                            
                                            play.toggle()
                                            
                                            switch play {
                                            case false:
                                                imagem = "play.circle.fill"
                                                player.pause()
                                            case true:
                                                if player.queue.entries.isEmpty {
                                                    playsSong(musica: musica)
                                                    imagem = "pause.circle.fill"
                                                }
                                                else {
                                                    resumeSong()
                                                    imagem = "play.circle.fill"
                                                }
                                            }
                                            
                                        } label: {
                                            Image(systemName: imagem)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.white)
                                        }
                                        
                                        Spacer()
                                        
                                        // barra de progresso da musica
                                        
                                        ZStack {
                                            Capsule().fill(Color.white.opacity(0.2)).frame(height: 5)
                                            
                                            HStack(spacing: 0) {
                                                Capsule().fill(Color.white).frame(width: 50, height: 5)
                                                
                                                Spacer()
                                            }
                                        }
                                        .padding(.horizontal, 4)
                                        
                                        Spacer()
                                        
                                        Text("-2:20")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    
                                    HStack(spacing: 16) {
                                        let infos = populateString(musica: musica)
                                        ScrollView(.horizontal, showsIndicators: false){
                                            HStack{
                                                ForEach(infos, id: \.self){ info in
                                                    GenreView (text: info)

                                                }
                                            }
                                        }
                                        .padding(.top, 8)
                                        
                                        VStack(spacing: 0) {
                                            Spacer()
                                            
                                            Button {
                                                addsToPlaylist(musica: musica)
                                            } label: {
                                                
                                                Image(systemName: "plus.app")
                                                    .resizable()
                                                    .frame(width: 18, height: 18)
                                                    .foregroundColor(.white)
                                                
                                            }
                                        }
                                        .frame(width: 20, height: 17)
                                        ShareLink(item: musica.url!) {
                                            Image(systemName: "square.and.arrow.up")
                                                .resizable()
                                                .frame(width: 18, height: 24)
                                                .foregroundColor(.white)
                                           }
                                    }
                                }

                            }
                            
                            
                            
                            /// Artista vem aqui
                            HStack {
                                Text("Sobre")
                                    .font(.footnote)
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            HStack {
                                VStack (alignment: .leading){
                                    Text("Álbum")
                                        .bold()
                                        .foregroundColor(.gray)
                                        .font(.system(size: 24))
                                    Text (music.albumTitle ?? "Indisponivel")
                                        .padding(.bottom, 16)
                                    Text("Compositor")
                                        .bold()
                                        .foregroundColor(.gray)
                                        .font(.system(size: 24))
                                    Text (music.composerName ?? "Indisponível")
                                        .padding(.bottom, 16)
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    }
                    .padding()
                }
            }
        }
        .background(self.bgColor)
        .opacity(0.9)
        .onAppear {
            viewModel.fetchMusic()
            
        }
    }
    
    func populateString (musica: Song) -> [String]{
        var aux = [String]()
        aux.append(musica.genreNames.first ?? "Indisponível")
        aux.append(musica.albumTitle ?? "Indisponível")
        let data = DateFormatter()
        data.dateFormat = "YYYY"
        aux.append(data.string(from: musica.releaseDate!) )
        return aux
    }
    
    func addsToPlaylist (musica: Song){
        Task{
            let library = MusicLibrary.shared
            let playlist = try await library.createPlaylist(name: "Recommendations")
            try await library.add(musica, to: playlist)
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
