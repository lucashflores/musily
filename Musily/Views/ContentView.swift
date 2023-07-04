import SwiftUI
import MusicKit
import MediaPlayer

struct ContentView: View {
    @State var authStatus: AuthStatus = .fetchingAuth
    @State var offer : Bool = false
    @AppStorage("showOnboarding") private var showOnboarding = true
    var body: some View {
        NavigationView {
            TabView{
                switch authStatus {
                case .fetchingAuth:
                    ProgressView()
                        .progressViewStyle(.circular)
                case .noMediaLibraryPermission:
                    InstructionsView()
//                case .noAppleMusicSubscription:
//                    SubscribeToAppleMusicView(isPresented: .constant(true))
                default:
                    TrackView(isPresented: $offer)
                    
                }
            }
            .onChange(of: showOnboarding, perform: { newValue in
                getAuth()
            })
            .onAppear {
                if !showOnboarding {
                    getAuth()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            ZStack {
                OnboardingView(showOnboarding: $showOnboarding)
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
    
    func authNotification (){
            Task{
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                   if success {
                       UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                       let content = UNMutableNotificationContent()
                       content.title = "Disc"
                       content.body = "Checkout your DISCovery of the day!"
                       var dateComponents = DateComponents()
                       dateComponents.hour = 0
                       dateComponents.minute = 0
                       dateComponents.second = 0
                       let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                       let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                       UNUserNotificationCenter.current().add(request)
                       print("User Accepted")
                   } else if let error = error {
                       print(error.localizedDescription)
                  }
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


