//
//  ContentView.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 20.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

extension EdgeInsets {

    static var zero: EdgeInsets {
        EdgeInsets()
    }

    init(horizontal: Length = 0, vertical: Length = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

}

extension Length {

    static var margin: Length { 8 }

    // TODO: Can we read the system padding?
    static var padding: Length { 16 }

    /// The least positive normal number.
    static var leastNormalMagnitude: Length { Length(Float.leastNormalMagnitude) }

    /// The least positive number.
    static var leastNonzeroMagnitude: Length { Length(Float.leastNonzeroMagnitude) }

}

// MARK: - Comics

struct ComicsItemView: View {

    @ObjectBinding var viewModel: ManagedObjectViewModel<ComicEntity>

    var body: some View {
        HStack {
            URLImageView(viewModel: URLImageViewModel(url: URL(string: viewModel.thumbnailURLString!)!))
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(radius: 4, x: 0, y: 1)
            VStack(alignment: .leading) {
                Text("\(viewModel.managedObject.cleanedTitle) (2019) #\(viewModel.issueNumber)")
                    .font(.headline)
                    .lineLimit(.max)
                    .truncationMode(.tail)
                Text("\(viewModel.managedObject.creators)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(.max)
                    .truncationMode(.tail)
            }
        }
    }

//    var body: some View {
//        Button(action: buttonTap) {
//            Text("\(viewModel.title ?? "nil")")
//                .lineLimit(.max)
//                .truncationMode(.tail)
//        }
//    }

//    func buttonTap() {
//        viewModel.isPulled.toggle()
//    }

}

struct ComicsSectionHeader: View {

    @State var title: String

    var body: some View {
        ZStack(alignment: .leading) {
            Color.white
            Text(title)
                .padding(EdgeInsets(horizontal: .padding))
        }
    }

}

struct ComicsSectionView: View {

    @State var sectionInfo: SectionInfo<ComicEntity>

    var body: some View {
        Section(header: ComicsSectionHeader(title: sectionInfo.name).listRowInsets(.zero)) {
            ForEach(self.sectionInfo.objects.identified(by: \.objectID)) { comic in
                ComicsItemView(viewModel: ManagedObjectViewModel(managedObject: comic))
                    .padding(EdgeInsets(vertical: .margin))
            }
        }
    }

}

struct ComicsView: View {

    @ObjectBinding var viewModel: FetchedObjectsViewModel<ComicEntity>

    var body: some View {
        if viewModel.sections.count < 1 {
            return Text("Empty").eraseToAnyView()
        } else {
            return List {
                ForEach(viewModel.sections.identified(by: \.name)) { sectionInfo in
                    ComicsSectionView(sectionInfo: sectionInfo)
                }
            }
            .eraseToAnyView()
        }
    }

}

// MARK: - Series

struct SeriesItemView: View {

    @ObjectBinding var viewModel: ManagedObjectViewModel<SeriesEntity>

    var body: some View {
        Text("\(viewModel.title ?? "nil")")
            .lineLimit(.max)
            .truncationMode(.tail)
    }

}

struct SeriesSectionHeader: View {

    @State var title: String

    var body: some View {
        ZStack(alignment: .leading) {
            Color.white
            Text(title)
                .font(.headline)
                .padding(EdgeInsets(horizontal: .padding, vertical: 3.0))
        }
    }

}

struct SeriesSectionView: View {

    @ObjectBinding var viewModel: ManagedObjectViewModel<SeriesEntity>

    var body: some View {
        VStack(alignment: .leading) {
            SeriesSectionHeader(title: viewModel.title ?? "")
            ScrollView(showsHorizontalIndicator: false) {
                HStack(alignment: .bottom) {
                    ForEach(Array<ComicEntity>(viewModel.comics as! Set<ComicEntity>).identified(by: \.objectID)) { comic in
                        URLImageView(viewModel: URLImageViewModel(url: URL(string: comic.thumbnailURLString!)!))
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(radius: 4, x: 0, y: 1)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            .frame(height: 120)
        }
    }

}

struct SeriesView: View {

    @ObjectBinding var viewModel: FetchedObjectsViewModel<SeriesEntity>

    var body: some View {
        List {
            // Use ForEach instead of the List initializer, because otherwise listRowInsets have no effect.
            ForEach(viewModel.fetchedObjects.identified(by: \.objectID)) { series in
                Section(header: Color.white.listRowInsets(.zero)) {
                    SeriesSectionView(viewModel: ManagedObjectViewModel(managedObject: series))
                        .listRowInsets(.zero)
                }
            }
        }
        .environment(\.defaultMinListHeaderHeight, .leastNonzeroMagnitude)
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
