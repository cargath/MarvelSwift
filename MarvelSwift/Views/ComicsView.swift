//
//  ComicsView.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 29.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

struct ComicsItemView: View {

    @ObjectBinding var viewModel: ManagedObjectViewModel<ComicEntity>

    var body: some View {
        HStack {
            URLImageView(viewModel: URLImageViewModel(url: viewModel.thumbnailURLString!.url!))
                .aspectRatio(contentMode: .fill)
                .frame(width: .thumbnailSize, height: .thumbnailSize)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous))
                .shadow(radius: 4, x: 0, y: 1)
            VStack(alignment: .leading) {
                Text("\(viewModel.managedObject.cleanedTitle)\n#\(viewModel.issueNumber)")
                    .color(.primary)
                    .font(.headline)
                    .lineLimit(.max)
                    .truncationMode(.tail)
                Text("\(viewModel.managedObject.creators)")
                    .color(.secondary)
                    .font(.subheadline)
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

#if DEBUG
struct ComicsView_Previews : PreviewProvider {
    static var previews: some View {
        ComicsView(viewModel: DataController.shared.solicitationsViewModel())
    }
}
#endif
