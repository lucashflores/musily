import SwiftUI
import MusicKit

struct TrackView: View {
    var cards: [MediaInformationCard]?
    var player = AppleMusicPlayer()
    @State var options = MusicSubscriptionOffer.Options(
        messageIdentifier: .playMusic
    )
    @State var sliderValue : Float = 0.0
    @ObservedObject var viewModel: TrackViewModel = TrackViewModel()
    @State var imagem = "play.circle.fill"
    @State var play = false
    @Binding var isPresented : Bool
    @State var duration : Float = 0.0
    
    var body: some View {
        
        ZStack {
            if (viewModel.song == nil) {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            else {
                if let music = viewModel.song {
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
                                        Text("Discovery")
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
                                                    offerMusic()
                                                    guard let musicKitSong = music.musicKitSong else { return }
                                                    player.playsSong(musica: musicKitSong)
                                                }
                                                else {
                                                    player.resumeSong()
                                                }
                                                imagem = "pause.circle.fill"
                                            }
                                            
                                        } label: {
                                            Image(systemName: imagem)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.white)
                                        }
                                        
                                        Spacer()
                                        
                                        // barra de progresso da musica
                                        Slider(value: $sliderValue, in: 0...Float(music.musicKitSong?.duration ?? 30)) {
                                            Text ("")
                                        } minimumValueLabel: {
                                            Text ("")
                                        } maximumValueLabel: {
                                            let float = Float(music.musicKitSong?.duration ?? 30)
                                            Text (String(describing: float))
                                        } onEditingChanged: { editing in
                                            player.updateInfo(value: sliderValue)
                                        } .accentColor(.white)
    //
    //                                    ZStack {
    //                                        Capsule().fill(Color.white.opacity(0.2)).frame(height: 5)
    //
    //                                        HStack(spacing: 0) {
    //                                            Capsule().fill(Color.white).frame(width: 50, height: 5)
    //
    //                                            Spacer()
    //                                        }
    //                                    }
    //                                    .padding(.horizontal, 4)
    //
    //                                    Spacer()
    //
    //                                    Text("-2:20")
    //                                        .font(.footnote)
    //                                        .foregroundColor(.white)
    //                                        .frame(width: 40, height: 40)
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
                                    Text(viewModel.artistInfo ?? "Indisponível")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                }
                                else {
                                    ProgressView()
                                }
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack{
                                        if let trackInfo = viewModel.trackInfo, let albumInfo = viewModel.albumInfo, let allGenreInformation = viewModel.allGenreInformation, let albums = viewModel.albums {
                                            
                                            if (trackInfo != "Indisponível")
                                            {
                                                CardView(cardInfo: MediaInformationCard(title: "The Track", content: trackInfo))
                                            }
                                            if (albumInfo != "Indisponível")
                                            {
                                                CardView(cardInfo: MediaInformationCard(title: "The Album", content: albumInfo))
                                            }
                                            
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
        }
        .musicSubscriptionOffer(isPresented: $isPresented, options: options)
        .toolbar(.hidden, for: .tabBar)
        .background(viewModel.bgColor)
        .opacity(0.9)
        .onAppear {
            viewModel.fetchContent()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                updateSlider()
            }
        }
        
    }
    
    
    func updateSlider () {
        sliderValue = Float(player.getPlaybackTime())
    }
    
    func offerMusic(){
        Task{
            let status = try await MusicSubscription.current
            if status.canBecomeSubscriber{
                isPresented.toggle()
                play = false
            }
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
        TrackView(isPresented: .constant(false))
    }
}
