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
    
    @State var disp: String = ""
    @State var var1: MusicAuthorization.Status?
    @State var var2: MusicSubscription?
    @State var errorReceived: Error?
    
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
            case .error:
                ErrorView()
            default:
                TrackView()
            }
        }
        .onAppear(perform: getAuth)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var debbugingView: some View {
        VStack {
            Text(disp)
            
            if let auth = var1 {
                Text("status = \(auth.rawValue)")
            }
            
            if let subs = var2 {
                Text("subStatus.canBecomeSubscriber = \(String(subs.canBecomeSubscriber))")
                Text("subStatus.canPlayCatalogContent = \(String(subs.canPlayCatalogContent))")
            }
            
            if let error = errorReceived {
                Text("error = \(error.localizedDescription)")
            }
            
        }
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
    case error
    case privacyPolicyNeedsAccepting
    case noMediaLibraryPermission
    case noAppleMusicSubscription
    case authorized
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
