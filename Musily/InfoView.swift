//
//  InfovIEW.swift
//  Musily
//
//  Created by Lucas Flores on 27/06/23.
//

import Foundation
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
                
                Text("Artista")
                    .bold()
                    .foregroundColor(.gray)
                    .font(.system(size: 24))
                Text (musica?.artistName ?? "Indisponível")
                    .padding(.bottom, 16)
                Text("Álbum")
                    .bold()
                    .foregroundColor(.gray)
                    .font(.system(size: 24))
                Text (musica?.albumTitle ?? "Indisponível")
                    .padding(.bottom, 16)
                Text("Compositor")
                    .bold()
                    .foregroundColor(.gray)
                    .font(.system(size: 24))
                Text (musica?.composerName ?? "Indisponível")
                    .padding(.bottom, 16)
                Group{
                    Text("Descrição")
                        .bold()
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                    Text (musica?.editorialNotes?.standard ?? "Indisponível")
                        .padding(.bottom, 16)
                    Text("Título")
                        .bold()
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                    Text (musica?.title ?? "Indisponível")
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
