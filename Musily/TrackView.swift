import SwiftUI
import MusicKit

struct TrackView: View {
    var cards: [MediaInformationCard]?
    var player = AppleMusicPlayer()
    var deepLinker = DeepLink()
    @State var options = MusicSubscriptionOffer.Options(
        messageIdentifier: .playMusic
    )
    @State var sliderValue : Float = 0.0
    @ObservedObject var viewModel: TrackViewModel = TrackViewModel()
    @State var imagem = "play.circle.fill"
    @State var play = false
    @Binding var isPresented : Bool
    @State var duration : Float = 0.0
    @State var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack {
            if (viewModel.song == nil){
                SplashScreen()
            }
            else{
                ScrollView {
                    ZStack {
                        if let music = viewModel.song {
                            ZStack {
                                VStack(spacing: 0) {
                                    
                                    Rectangle()
                                        .frame(maxWidth: .infinity, maxHeight: 180)
                                        .foregroundColor(Color(uiColor: .clear))
                                        .overlay {
                                            LinearGradient(
                                                colors: [Color("purple"), Color("purple") .opacity(0.5), Color(uiColor: .clear)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                            .ignoresSafeArea()
                                        }
                                    
                                    Spacer()
                                }
                                
                                VStack {
                                    VStack(spacing: 32) {
                                        
                                        
                                        HStack(spacing: 0) {
                                            Image("DiscoveryOfTheDay")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: 230)
                                        }
                                        .padding(.top, 70)
                                        .padding(.bottom, 20)
                                        
                                        AsyncImage(url: music.artistArtworkURL)
                                            .frame(width: 350, height: 350, alignment: .center)
                                            .cornerRadius(24)
                                        
                                        VStack(spacing: 8) {
                                            
                                            VStack(spacing: 6) {
                                                
                                                HStack {
                                                    Text(music.title ?? "Indisponível")
                                                        .font(.title)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                }
                                                
                                                HStack {
                                                    Text(music.artistName ?? "Indisponível")
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                        .fontWeight(.regular)
                                                        .opacity(0.6)
                                                    
                                                    Spacer()
                                                }
                                            }
                                            
                                            
                                            
                                            VStack(spacing: 10) {
                                                
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
                                                        let tempo = Float(music.musicKitSong?.duration ?? 30)
                                                        let min = Int(tempo / 60)
                                                        let sec = Int(tempo - (Float(min * 60)))
                                                        Text (sec < 10 ? "-\(min):0\(sec)" : "-\(min):\(sec)")
                                                            .font(.footnote)
                                                            .foregroundColor(.white)
                                                            .bold()
                                                        
                                                    } onEditingChanged: { editing in
                                                        if editing == false{
                                                            offerMusic()
                                                            timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
                                                            player.updateInfo(value: sliderValue)
                                                        } else{
                                                            self.timer.upstream.connect().cancel()
                                                        }
                                                    } .accentColor(.white)
                                                }
                                                
                                                
                                                HStack(spacing: 16) {
                                                    let infos = populateString(song: music)
                                                    ScrollView(.horizontal, showsIndicators: false){
                                                        HStack(spacing: -10){
                                                            ForEach(infos, id: \.self){ info in
                                                                GenreView (text: info)
                                                                
                                                            }
                                                        }
                                                    }
                                                    .padding(.top, 8)
                                                    
                                                    ShareLink(item: music.songURL) {
                                                        Image(systemName: "square.and.arrow.up")
                                                            .resizable()
                                                            .frame(width: 18, height: 24)
                                                            .foregroundColor(.white)
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                        /// Artista vem aqui
                                        VStack (alignment: .leading){
                                            HStack(spacing: 4){
                                                Text("ABOUT")
                                                    .font(.title3)
                                                    .foregroundColor(Color("green"))
                                                    .bold()
                                                
                                                Text("the artist")
                                                    .foregroundColor(Color("green"))
                                                    .font(.title3)
                                                
                                                Spacer()
                                            }
                                            .frame(maxHeight: 10)
                                            .padding(.vertical)
                                            
                                            Text(viewModel.artistInfo ?? "Unavailable")
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.leading)
                                                .font(.footnote)
                                                .bold()
                                            
                                        }
                                        
                                        
                                        
                                        HStack {
                                            Image("DiscoverMore")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: 200)
                                            
                                            Spacer()
                                            
                                        }
                                        .padding(.vertical, -16)
                                        .padding(.top, 48)
                                        
                                        ScrollView(.horizontal, showsIndicators: false){
                                            HStack (spacing: 16){
                                                if let trackInfo = viewModel.trackInfo, let albumInfo = viewModel.albumInfo, let allGenreInformation = viewModel.allGenreInformation, let albums = viewModel.albums {
                                                    
                                                    if (trackInfo != "Unavailable")
                                                    {
                                                        CardView(cardInfo: MediaInformationCard(title: "The Track", content: trackInfo))
                                                    }
                                                    if (albumInfo != "Unavailable")
                                                    {
                                                        CardView(cardInfo: MediaInformationCard(title: "The Album", content: albumInfo))
                                                    }
                                                    
                                                    ForEach(allGenreInformation)
                                                    { genre in
                                                        CardView(cardInfo: MediaInformationCard(title: "The Genre - \(genre.genreName)", content: genre.genreInfo ?? "loading"))
                                                        
                                                    }
                                                    
                                                    ForEach(albums)
                                                    { album in
                                                        Button {
                                                            if let url = album.albumURL {
                                                                deepLinker.redirect(url: url)
                                                            }
                                                        } label: {
                                                            AlbumCardView(albumCardInfo: album)
                                                        }
                                                        
                                                        
                                                        
                                                    }
                                                }
                                                else {
                                                    ProgressView()
                                                }
                                            }
                                            
                                            
                                            
                                        }
                                        
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(32)
                                }
                            }
                        }
                    }
                    .background(.black)
                }
            }
        }
        .musicSubscriptionOffer(isPresented: $isPresented, options: options)
        .toolbar(.hidden, for: .tabBar)
        .opacity(0.9)
        .onReceive(timer, perform: { input in
            updateSlider()
        })
        .onAppear {
            viewModel.fetchContent()
        }
        .background {
            if let _ = viewModel.song {
                VStack(spacing: 0){
                    Rectangle()
                        .fill(Color("purple"))
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 180)
                        .foregroundColor(Color(uiColor: .clear))
                        .overlay {
                            LinearGradient(
                                colors: [Color("purple"), .black],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                        }
                    
                    Rectangle()
                        .fill(.black)
                }
            } else {
                Color(.white)
            }
        }
        .ignoresSafeArea()
        
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
        var aux = [String]()
        aux.append("Genre: " + song.genreNames.first!)
        aux.append("Album: " + (song.albumTitle ?? "Unavailable"))
        let data = DateFormatter()
        data.dateFormat = "YYYY"
        aux.append("Year: " + data.string(from: song.releaseDate!))
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
