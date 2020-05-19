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
            CoverImage(url: viewModel.thumbnailURLString!.url!)
                .frame(width: .thumbnailWidth, height: .thumbnailHeight)
            VStack(alignment: .leading, spacing: 0) {
                Text("\(viewModel.managedObject.cleanedTitle)")
                    .foregroundColor(.primary)
                    .font(.headline)
                    .lineLimit(.max)
                    .truncationMode(.tail)
                    .padding(.top, 6)
                Text("\(viewModel.managedObject.creators)")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .lineLimit(.max)
                    .truncationMode(.tail)
                    .padding(.top, 2)
                Spacer()
                IssueNumber(issueNumber: viewModel.issueNumber)
            }
            Spacer()
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
            ForEach(sectionInfo.objects.identified(by: \.objectID)) { comic in
                // NavigationLink(destination: ComicDetailView()) {
                    ComicsItemView(viewModel: ManagedObjectViewModel(managedObject: comic))
                        .padding(EdgeInsets(vertical: .margin))
                // }
            }
        }
    }

}

struct ComicsView: View {

    @ObjectBinding var viewModel: FetchedObjectsViewModel<ComicEntity>

    var body: some View {
        ZStack {
            if viewModel.sections.count < 1 {
                VStack {
                    Image(systemName: "archivebox.fill").font(.title).padding()
                    Text("Empty")
                }
                .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(viewModel.sections.identified(by: \.name)) { sectionInfo in
                        ComicsSectionView(sectionInfo: sectionInfo)
                    }
                }
            }
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
