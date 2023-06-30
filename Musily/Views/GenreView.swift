//
//  GenreView.swift
//  Musily
//
//  Created by Tiago Mendes Bottamedi on 28/06/23.
//

import SwiftUI

struct GenreView: View {
    var text : String
    var body: some View {
        Text(text)
            .padding(.horizontal)
            .background(Color("cinzaApp"))
            .cornerRadius(16)
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView(text: "Pop")
    }
}
