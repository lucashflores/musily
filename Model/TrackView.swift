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
    @State var imagem = "play.circle.fill"
    @State var bgColor = Color("bkDarkColor")
    let player = ApplicationMusicPlayer.shared
    
    var body: some View {
        if let musica = musicGetter.song {
            ZStack {
                
                VStack(spacing: 0) {
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(Color(uiColor: .clear))
                        .overlay {
                            LinearGradient(
                                colors: [.white, Color(uiColor: .clear), Color(uiColor: .clear), .black],
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
                            
                            AsyncImage(url: musica.artists?.first?.artwork?.url(width: 330, height: 330))
                                .frame(width: 330, height: 330, alignment: .center)
                                .cornerRadius(16)
                            
                            HStack{
                                VStack(spacing: 0) {
                                    Text(musica.title)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text(musica.artistName)
                                        .font(.headline)
                                        .fontWeight(.light)
                                        .foregroundColor(.white)

                                }
                                Spacer()
                            }
                            
                            
                            HStack {

                                Button {
                                    if player.state.playbackStatus == .playing {
                                        imagem = "play.circle.fill"
                                        player.pause()

                                    } else {
                                        imagem = "pause.circle.fill"
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
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
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
                                    ForEach(musica.genreNames, id: \.self){ genre in
                                        GenreView (text: genre)
                                            
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
                                    Text (musica.albumTitle ?? "Indisponivel")
                                        .padding(.bottom, 16)
                                    Text("Compositor")
                                        .bold()
                                        .foregroundColor(.gray)
                                        .font(.system(size: 24))
                                    Text (musica.composerName ?? "Indisponível")
                                        .padding(.bottom, 16)
                                }
                                Spacer()
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    }
                    .padding()
                }
            }
            .background(bgColor)
            .opacity(0.9)
            .onAppear {
                let url = musica.artwork?.url(width: 300, height: 300)
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        bgColor = Color(uiColor: image!.averageColor!)
                    }
                }
                
            }
            
            
            
        }else {
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

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
