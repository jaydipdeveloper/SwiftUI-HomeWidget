//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by Jaydip  on 27/04/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct HomeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                let allDays = DateFormatter().weekdaySymbols
                
                //MARK:- List View
                VStack {
                    ForEach(allDays ?? [], id: \.self) { prayer in
                        CreateCellRow(object: prayer)
                    }
                }
            }.padding(.top, 5.0)
        }
    }
}

@main
struct HomeWidget: Widget {
    let kind: String = "HomeWidget"
    let backgroundColor = Color.black
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            backgroundColor.overlay (
                HomeWidgetEntryView(entry: entry)
            )
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("My Widget")
        .description("Add Day widget to home screen.")
    }
}

struct HomeWidget_Previews: PreviewProvider {
    static var previews: some View {
        HomeWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

//MARK:- Cell Layout
struct CreateCellRow: View {
    let object: String
    
    let font = Font.system(size: 15.0).weight(.bold)
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .leading) {
                    let textColor = Color.white
                    Rectangle().frame(width: geometry.size.width)
                        .opacity(0.3).foregroundColor(.gray)
                        .padding(.top, 2.5).padding(.bottom, 2.5)
                    
                    Text(object).font(font).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 7.5)
                        .foregroundColor(textColor)
                }
            }.padding(.top, -10.0).padding(.leading, 0.0).padding(.trailing, 0.0)
        }
    }
}
