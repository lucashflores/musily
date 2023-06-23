//
//  ContentView.swift
//  Musily
//
//  Created by Lucas Flores on 21/06/23.
//

import SwiftUI
import MusicKit
import MediaPlayer

struct ContentView: View {
    @ObservedObject var musicGetter = MusicGetter()

    var body: some View {
        TabView{
            TrackView()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
        .background(Color("bkDarkColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
