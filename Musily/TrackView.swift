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
                                        Text(music.title ?? "Unavailable")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                    }
                                    
                                    HStack {
                                        Text(music.artistName ?? "Unavailable")
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
                                            let minutes = float / 60
                                            let integerPart = Int(minutes) % 10
                                            let seconds = Int(((minutes - Float(integerPart)) * 6000)) % 100
                                            Text (String(describing: "\(integerPart):\(seconds)"))
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
                                            HStack{
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
                                           }
                                    }
                                }

                            }
                                
                                /// Artista vem aqui
                                HStack {
                                    Text("About the artist")
                                        .font(.footnote)
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                if (viewModel.artistInfo != nil)
                                {
                                    Text(viewModel.artistInfo ?? "Unavailable")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                }
                                else {
                                    ProgressView()
                                }
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack{
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
        .onReceive(timer, perform: { input in
                    updateSlider()
                })
        .onAppear {
            viewModel.fetchContent()
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
        aux.append(song.albumTitle ?? "Unavailable")
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
