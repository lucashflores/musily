import SwiftUI

struct GenreView: View {
    var text : String
    var body: some View {
        let names = text.split(separator: ":")
        HStack (spacing: 0){
            Text(names[0] + ":")
                .foregroundColor(.white)
                .opacity(0.6)
                .font(.footnote)
            Text (names[1])
                .foregroundColor(.white)
                .font(.footnote)
        }.padding(.horizontal, 10)
            .padding(.vertical, 5)

                
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("green"), lineWidth: 2)
//                .padding(.horizontal, 10)
                
        ).padding(.horizontal, 10)
            .padding(.vertical, 5)

    }
    
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView(text: "Genre: Pop")
    }
}
