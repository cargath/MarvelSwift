//
//  SeriesView.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 29.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

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
        VStack(alignment: .leading, spacing: 0) {
            SeriesSectionHeader(title: viewModel.title ?? "")
            ScrollView(showsHorizontalIndicator: false) {
                HStack(alignment: .center) {
                    ForEach(Array<ComicEntity>(viewModel.comics as! Set<ComicEntity>).identified(by: \.objectID)) { comic in
                        CoverImage(url: comic.thumbnailURLString!.url!)
                            .frame(width: .thumbnailWidth, height: .thumbnailHeight)
                        //URLImageView(viewModel: URLImageViewModel(url: URL(string: comic.thumbnailURLString!)!))
                            //.aspectRatio(contentMode: .fill)
                            //.frame(width: .thumbnailSize, height: .thumbnailSize)
                            //.background(Color.gray)
                            //.clipShape(RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous))
                            //.shadow(radius: 4, x: 0, y: 1)
                            .padding(.trailing, .padding)
                    }
                }
                .frame(height: .thumbnailHeight + .padding)
                .padding(.leading, .padding)
            }
            .frame(height: .thumbnailHeight + .padding)
        }
        .padding(.bottom, .padding)
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

#if DEBUG
struct SeriesView_Previews : PreviewProvider {
    static var previews: some View {
        SeriesView(viewModel: DataController.shared.subscriptionsViewModel())
    }
}
#endif
