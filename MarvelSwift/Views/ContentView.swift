//
//  ContentView.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 20.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

// MARK: - Comics

struct ComicsItemView: View {

    // TODO: @ObjectBinding doesn't compile, but seems like a better choice here?
    @State var comic: ComicEntity

    var body: some View {
        Text("\(comic.title ?? "nil")")
    }

}

struct ComicsView: View {

    @ObjectBinding var viewModel: FetchedObjectsViewModel<ComicEntity>

    var body: some View {
        List {
            ForEach(viewModel.fetchedObjects.identified(by: \.uniqueIdentifier)) { comic in
                ComicsItemView(comic: comic)
            }
        }
    }

}

// MARK: - Series

struct SeriesItemView: View {

    // TODO: @ObjectBinding doesn't compile, but seems like a better choice here?
    @State var series: SeriesEntity

    var body: some View {
        Text("\(series.title ?? "nil")")
    }

}

struct SeriesView: View {

    @ObjectBinding var viewModel: FetchedObjectsViewModel<SeriesEntity>

    var body: some View {
        List {
            ForEach(viewModel.fetchedObjects.identified(by: \.uniqueIdentifier)) { series in
                SeriesItemView(series: series)
            }
        }
    }

}

// MARK: - Navigation

struct SolicitsView: View {

    var body: some View {
        NavigationView {
            ComicsView(viewModel: DataController.shared.solicitationsViewModel())
                .navigationBarTitle(Text("Solicits"))
                .navigationBarItems(trailing: Button(action: {
                    DataController.shared.update()
                }) {
                    Image(systemName: "arrow.2.circlepath")
                })
        }
    }

}

struct PullsView: View {

    var body: some View {
        NavigationView {
            ComicsView(viewModel: DataController.shared.pullListViewModel())
                .navigationBarTitle(Text("Pull List"))
        }
    }

}

struct SubscriptionsView: View {

    var body: some View {
        NavigationView {
            SeriesView(viewModel: DataController.shared.subscriptionsViewModel())
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
