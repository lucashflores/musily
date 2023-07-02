import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack{
            Text("You need to enable this app's access to Apple Music.")
        }
        .onAppear(perform: openURl) 
    }
    
    func openURl(){
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
