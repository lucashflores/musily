//
//  AlbumCardView.swift
//  Musily
//
//  Created by Lucas Flores on 01/07/23.
//

import SwiftUI

struct AlbumCardView: View {
    var albumCardInfo: AppleMusicAlbum
    
    var body: some View {
        VStack (alignment: .leading){
            Spacer()
            Text("Other Albums")
                .foregroundColor(Color(uiColor: .white))
                .font(.body)
                .bold()
                .opacity(0.8)
            Text (albumCardInfo.title ?? "Indisponível")
                .foregroundColor(.white)
                .font(.title2)
                .bold()
            
        }
        .padding()
        .frame(width: 240, height: 240, alignment: .leading)
        .background(ZStack {
            AsyncImage(url: albumCardInfo.artworkURL)
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0), .black.opacity(0.3), .black.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
        })
        .cornerRadius(16)
    }
}

struct AlbumCardView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumCardView(albumCardInfo: AppleMusicAlbum.getDefault())
    }
}
