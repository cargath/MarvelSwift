//
//  ContentView.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 20.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

// MARK: - Comics

struct Comic {

    var id: Int = .random(in: 0 ... .max)

    var title: String

    var issueNumber: Int

}

struct ComicsItemView: View {

    @State var comic: Comic

    var body: some View {
        Text("\(comic.title) (2019) #\(comic.issueNumber)")
    }

}

struct ComicsView: View {

    @State var comics = [
        Comic(title: "Captain Marvel", issueNumber: 1),
        Comic(title: "Captain Marvel", issueNumber: 2),
        Comic(title: "Captain Marvel", issueNumber: 3)
    ]

    @State private var searchQuery = ""

    var body: some View {
        List {
            ForEach(comics.identified(by: \.id)) { comic in
                ComicsItemView(comic: comic)
            }
        }
    }

}

// MARK: - Series

struct SeriesItemView: View {

    var body: some View {
        Text("Captain Marvel (2019)")
    }

}

struct SeriesView: View {

    var body: some View {
        List(0 ... 42) { _ in
            SeriesItemView()
        }
    }

}

// MARK: - Navigation

struct SolicitsView: View {

    var body: some View {
        NavigationView {
            ComicsView()
                .navigationBarTitle(Text("Solicits"))
        }
    }

}

struct PullsView: View {

    var body: some View {
        NavigationView {
            ComicsView()
                .navigationBarTitle(Text("Pull List"))
        }
    }

}

struct SubscriptionsView: View {

    var body: some View {
        NavigationView {
            SeriesView()
                .navigationBarTitle(Text("Subscriptions"))
        }
    }

}

// MARK: - Content

struct ContentView: View {

    @State private var selection = 0

    var body: some View {
        TabbedView(selection: $selection) {
            SolicitsView()
                .tabItemLabel(Text("Solicits"))
                .tag(0)
            PullsView()
                .tabItemLabel(Text("Pull List"))
                .tag(1)
            SubscriptionsView()
                .tabItemLabel(Text("Subscriptions"))
                .tag(2)
        }
        .accentColor(Color.red)
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
