//
//  CardView.swift
//  Musily
//
//  Created by Tiago Mendes Bottamedi on 29/06/23.
//

import SwiftUI

struct CardView: View {
    var body: some View {
            VStack (alignment: .leading){
                Text("Lorem ipsum dolor sit amet. Vel animi libero qui tempore dolores aut animi libero in quibusdam minus non quia fuga aut dolor corrupti. Hic excepturi nihil qui adipisci earum sit iure galisum id atque laudantium est nihil eligendi. Est optio internos aut amet tempora sit neque doloremque vel provident voluptate ea nisi modi ea labore delectus. Quo laboriosam commodi aut quod obcaecati sit magni impedit.")
                    .foregroundColor(.white)
                    .font(.caption)
                Spacer()
                Text ("The Album")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                
            }
            .padding()
            .frame(width: 240, height: 240, alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [.white.opacity(0.5), .white.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(16)
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}

