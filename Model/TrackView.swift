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
    @State var share = "square.and.arrow.up"
    @State var bgColor = Color("bkDarkColor")
    @State var play = false
    private let copia = UIPasteboard.general

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
                            
                            AsyncImage(url: musica.artists?.first?.artwork?.url(width: 330, height: 330))
                                .frame(width: 330, height: 330, alignment: .center)
                                .cornerRadius(16)
                            
                            VStack(spacing: 16) {
                                
                                VStack(spacing: 0) {
                                    
                                    HStack {
                                        Text(musica.title)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                    }
                                    
                                    HStack {
                                        Text(musica.artistName)
                                            .font(.headline)
                                            .fontWeight(.light)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                }
                                
                                
                                VStack(spacing: 0) {
                                    
                                    HStack {

                                        Button {
//                                            if player.state.playbackStatus == .playing {
//                                                imagem = "play.circle.fill"
//                                                player.pause()
//
//                                            } else {
//                                                imagem = "pause.circle.fill"
//                                                if player.queue.entries.isEmpty {
//                                                    playsSong(musica: musica)
//                                                }
//                                                else {
//                                                    resumeSong()
//                                                    imagem = "play.circle.fill"
//                                                }
//                                            }
                                            
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
                            Text("""
    Lorem ipsum dolor sit amet. Vel animi libero qui tempore dolores aut animi libero in quibusdam minus non quia fuga aut dolor corrupti. Hic excepturi nihil qui adipisci earum sit iure galisum id atque laudantium est nihil eligendi. Est optio internos aut amet tempora sit neque doloremque vel provident voluptate ea nisi modi ea labore delectus. Quo laboriosam commodi aut quod obcaecati sit magni impedit.
    """)
                                .font(.footnote)
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(1..<6) { i in             CardView()
                                    }
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    }
                    .padding()
                }
            }
            .toolbar(.hidden, for: .tabBar)
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
