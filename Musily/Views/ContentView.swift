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
                do {
                    let subStatus = try await MusicSubscription.current
        
                    if (subStatus.canBecomeSubscriber) {
                        DispatchQueue.main.async {
                            self.authStatus = .noAppleMusicSubscription
                            
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.authStatus = .authorized
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.authStatus = .error
                    }
                }
                break
            default:
                DispatchQueue.main.async {
                    self.authStatus = .noMediaLibraryPermission
                }
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
    case error
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
