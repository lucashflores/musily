//
//  DiscWidget.swift
//  DiscWidget
//
//  Created by Tiago Mendes Bottamedi on 03/07/23.
//

import WidgetKit
import SwiftUI
import MusicKit
//import Musily

//struct AppleMusicSong {
//    static func getDefault() -> AppleMusicSong {
//        return AppleMusicSong()
//    }
//}


//struct TrackViewModel3 {
//
//    var song: AppleMusicSong? = AppleMusicSong.getDefault()
//}

struct Provider: TimelineProvider {
    var viewModel: TrackViewModel2 = TrackViewModel2()
    var completion: ((Timeline<SimpleEntry>) -> Void)?
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Sim", artist: "Ele mesmo", image: UIImage(systemName: "photo.fill"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), title: "Sim", artist: "Ele mesmo", image: UIImage(systemName: "photo.fill"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task {
            var entries: [SimpleEntry] = []
            let currentDate = Date()
            let midnight = Calendar.current.startOfDay(for: currentDate)
            let status = await MusicAuthorization.request()
            switch status{
            case .authorized:
                await viewModel.fetchMusic()
                let entry = SimpleEntry(date: currentDate, title: viewModel.song!.title!, artist: viewModel.song!.artistName!, image: viewModel.image!)
                print (String(describing: viewModel.image!))
                entries.append(entry)
                let updateDate = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!

                let timeline = Timeline(entries: entries, policy: .after(updateDate))
                completion(timeline)
            default:
                let entry = SimpleEntry(date: currentDate, title: "", artist: "You need to enable this app's access to your Music Library", image: UIImage(systemName: "photo.fill"))
                entries.append(entry)
                let updateDate = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!

                let timeline = Timeline(entries: entries, policy: .after(updateDate))
                completion(timeline)
            }
        
        }
       
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let artist: String
    let image : UIImage?
}

struct DiscWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            Spacer()
            Image ("logo")
            Text (entry.title)
                .foregroundColor(.white)
                .bold()
            Text (entry.artist)
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 169, height: 169, alignment: .leading)
        .background(
            Image(uiImage: entry.image!)
                .resizable()
                .scaledToFill()
        )
    }
}

struct DiscWidget: Widget {
    let kind: String = "DiscWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(viewModel: TrackViewModel2())) { entry in
            DiscWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct DiscWidget_Previews: PreviewProvider {
    static var previews: some View {
        DiscWidgetEntryView(entry: SimpleEntry(date: Date(), title: "Sim", artist: "Ele mesmo", image: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
