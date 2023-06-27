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
    @State var authStatus: AuthStatus = .fetchingAuth
    var body: some View {
        TabView{
            switch authStatus {
            case .fetchingAuth:
                ProgressView()
                    .progressViewStyle(.circular)
            case .noMediaLibraryPermission:
                InstructionsView()
            case .noAppleMusicSubscription:
                SubscribeToAppleMusicView()
            default:
                TrackView()
            }
        }
        .onAppear(perform: getAuth)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    func getAuth() {
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                let subStatus = try await MusicSubscription.current
                if (subStatus.canBecomeSubscriber) {
                    self.authStatus = .noAppleMusicSubscription
                }
                else {
                    self.authStatus = .authorized
                }
                break
            default:
                break
            }
        }
    }
}

enum AuthStatus {
    case fetchingAuth
    case noMediaLibraryPermission
    case noAppleMusicSubscription
    case authorized
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
