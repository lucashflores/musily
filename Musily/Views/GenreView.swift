import SwiftUI

struct GenreView: View {
    var text : String
    var body: some View {
        Text(text)
            .padding(.horizontal)
            .padding(.vertical, 4)
            .font(.footnote)
            .background(Color("cinzaApp"))
            .cornerRadius(16)
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView(text: "Pop")
    }
}
