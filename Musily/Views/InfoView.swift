import SwiftUI
import MusicKit

struct InfoView: View {
    var musica : Song?
    var body: some View {
                    
            VStack (alignment: .leading) {
                AsyncImage (url: musica?.artwork?.url(width: 300, height: 300))
                    .frame(width: 300, height: 300)
                    .cornerRadius(32)
                    .overlay {
                        VStack {
                            Spacer()
                            Button(action: {}, label: {
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 64))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(8)
                            })
                        }
                        
                    } .padding(.bottom, 16)
                
                Group{
                    Text("Artista")
                        .bold()
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                    Text (musica?.artistName ?? "Unavailable")
                        .padding(.bottom, 16)
                    Text("Álbum")
                        .bold()
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                    Text (musica?.albumTitle ?? "Unavailable")
                        .padding(.bottom, 16)
                    Text("Compositor")
                        .bold()
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                    Text (musica?.composerName ?? "Unavailable")
                        .padding(.bottom, 16)
                        Text("Descrição")
                            .bold()
                            .foregroundColor(.gray)
                            .font(.system(size: 24))
                        Text (musica?.description ?? "Unavailable")
                            .padding(.bottom, 16)
                        Text("Título")
                            .bold()
                            .foregroundColor(.gray)
                            .font(.system(size: 24))
                        Text (musica?.title ?? "Unavailable")
                            .padding(.bottom, 16)
                }
               
            } .padding(.horizontal, 32)
                
        }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
