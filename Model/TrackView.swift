//
//  TrackView.swift
//  Musily
//
//  Created by Isabela Bastos Jastrombek on 22/06/23.
//

import SwiftUI
import MusicKit

//struct Item: Identifiable, Hashable {
//    var id = UUID()
//    let name: String
//    let artist: String
//    let imageURL: URL?
//}


var id = UUID()
let name = "Zap Zum"
let artist = "Pabllo Vittar"
let imageURL = "https://i.scdn.co/image/ab67616d0000b2737755000541025fddf488b6c5"


struct TrackView: View {
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            Text("Recomendação do dia")
                .font(.headline)
                .foregroundColor(.white)
            
            AsyncImage(url: URL(string: imageURL)){ image in image.resizable() } placeholder: { Color.gray } .frame(width: 330, height: 330) .clipShape(RoundedRectangle(cornerRadius: 20))
               
            VStack {
                Text(name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(artist)
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                
                
                Text("Placheholder do player")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
            }
            
            
            Button {
                
            } label: {
                HStack {
                    Group {
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .font(.title3)
                        
                        Text("Nova música")
                            .font(.callout)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    
                    
                }
                .padding()
                .padding(.horizontal, 8)
                .background(LinearGradient(gradient: Gradient(colors: [Color("AccentColor1"), Color("AccentColor2")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(38)
            }
            
            Spacer()
            
            Image("ListenOnAppleMusic")
                        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
        .background(Color("bkDarkColor"))
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
