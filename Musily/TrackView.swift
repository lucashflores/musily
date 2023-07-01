import SwiftUI
import MusicKit

struct TrackView: View {
    var cards: [MediaInformationCard]?
    private var player = AppleMusicPlayer()
    @ObservedObject private var viewModel: TrackViewModel = TrackViewModel()
    @State var imagem = "play.circle.fill"
    @State var play = false
    
    
    var body: some View {
        
        ZStack {
            if (viewModel.song == nil) {
                ProgressView()
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
                        
                        VStack(spacing: 16) {
                            
                            VStack(spacing: 0) {
                                
                                HStack {
                                    Text(music.title ?? "Indisponível")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                }
                                
                                HStack {
                                    Text(music.artistName ?? "Indisponível")
                                        .font(.headline)
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                            }
                            
                            
                            VStack(spacing: 0) {
                                
                                HStack {

                                    Button {
                                        play.toggle()
                                        
                                        switch play {
                                        case false:
                                            imagem = "play.circle.fill"
                                            player.pause()
                                        case true:
                                            if (player.isPlayerQueueEmpty()) {
                                                guard let musicKitSong = music.musicKitSong else { return }
                                                player.playsSong(musica: musicKitSong)
                                                imagem = "pause.circle.fill"
                                            }
                                            else {
                                                player.resumeSong()
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
                                    let infos = populateString(song: music)
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
                                            guard let musicKitSong = music.musicKitSong else { return }
                                            player.addsToPlaylist(musica: musicKitSong)
                                        } label: {
                                            
                                            Image(systemName: "plus.app")
                                                .resizable()
                                                .frame(width: 18, height: 18)
                                                .foregroundColor(.white)
                                            
                                        }
                                    }
                                    .frame(width: 20, height: 17)
                                    ShareLink(item: music.songURL) {
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
                            if (viewModel.artistInfo != nil)
                            {
                                Text(viewModel.artistInfo ?? "Indispnível")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                            else {
                                ProgressView()
                            }
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    if let allGenreInformation = viewModel.allGenreInformation, let albumInfo = viewModel.albumInfo, let albums = viewModel.albums {
                                        CardView(cardInfo: MediaInformationCard(title: "The Album", content: albumInfo))
                                        ForEach(allGenreInformation)
                                        { genre in
                                            CardView(cardInfo: MediaInformationCard(title: "The Genre - \(genre.genreName)", content: genre.genreInfo ?? "loading"))

                                        }
                                        
                                        ForEach(albums)
                                        { album in
                                            AlbumCardView(albumCardInfo: album)

                                        }
                                    }
                                    else {
                                        ProgressView()
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
        }
        .toolbar(.hidden, for: .tabBar)
        .background(viewModel.bgColor)
        .opacity(0.9)
        .onAppear() {
            viewModel.fetchContent()
        }
        
    }
    
    func populateString (song: AppleMusicSong) -> [String]{
        var aux = song.genreNames
        aux.append(song.albumTitle ?? "Indisponível")
        let data = DateFormatter()
        data.dateFormat = "YYYY"
        aux.append(data.string(from: song.releaseDate!) )
        return aux
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
