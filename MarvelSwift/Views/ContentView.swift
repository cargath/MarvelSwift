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

    static var padding: Length {
        16 // TODO: Can we read the system layout margins?
    }

    static var cornerRadius: Length { 12 }

    static var thumbnailSize: Length { 100 }

    static var thumbnailWidth: Length { 168.3 * 0.5 }

    static var thumbnailHeight: Length { 260 * 0.5 }

}

// Without manually casting to Length, .environment(\.defaultMinListHeaderHeight, .leastNonzeroMagnitude) doesn't get rid of the List separators.
extension Length {

    /// The least positive normal number.
    static var leastNormalMagnitude: Length { Length(Float.leastNormalMagnitude) }

    /// The least positive number.
    static var leastNonzeroMagnitude: Length { Length(Float.leastNonzeroMagnitude) }

}

/*
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

    enum Tab: Int {
        case solicitations
        case pullList
        case subscriptions
    }

    @State private var selection = 0

    var body: some View {
        TabbedView(selection: $selection) {
            SolicitsView()
                .tabItemLabel(Text("Solicits"))
                .tag(Tab.solicitations.rawValue)
            PullsView()
                .tabItemLabel(Text("Pull List"))
                .tag(Tab.pullList.rawValue)
            SubscriptionsView()
                .tabItemLabel(Text("Subscriptions"))
                .tag(Tab.subscriptions.rawValue)
        }
        .accentColor(Color.red)
    }

}
*/

// MARK: - Display options

import Combine

struct DisplayOptions {

    enum Filter: String, CaseIterable {
        case all = "All"
        case notPulled = "Not pulled"
        case pulled = "Pull List"
    }

    enum Layout: String, CaseIterable {
        case list = "List"
        case grid = "Grid"
        case carousel = "Carousel"
    }

    enum Sort: String, CaseIterable {
        case date = "Date"
        case series = "Series"
    }

    var filter: Filter

    var layout: Layout

    var sortBy: Sort

    static let `default` = DisplayOptions(filter: .all, layout: .list, sortBy: .date)

}

extension DisplayOptions.Filter {

    var systemImageName: String {
        switch self {
            case .all:
                return "line.horizontal.3.decrease.circle"
            case .notPulled:
                return "line.horizontal.3.decrease.circle.fill"
            case .pulled:
                return ""
        }
    }

    var predicate: NSPredicate? {
        switch self {
            case .all:
                return nil
            case .notPulled:
                return NSPredicate(format: "isPulled == false && series.isPulled == false")
            case .pulled:
                return NSPredicate(format: "isPulled == true || series.isPulled == true")
        }
    }

}

extension DisplayOptions.Sort {

    var sortDescriptors: [NSSortDescriptor] {
        switch self {
            case .date:
                return [
                    NSSortDescriptor(ascending: "releaseDate"),
                    NSSortDescriptor(ascending: "title")
                ]
            case .series:
                return [
                    NSSortDescriptor(ascending: "series.title"),
                    NSSortDescriptor(ascending: "title")
                ]
        }
    }

    var sectionName: String {
        switch self {
            case .date:
                return "releaseDateSectionName"
            case .series:
                return "seriesTitleSectionName"
        }
    }

}

struct DisplayOptionsForm: View {

    @Binding var isPresented: Bool

    @Binding var displayOptions: DisplayOptions

    var body: some View {
        NavigationView {
            Form {
                // "Layout" picker
                Picker(selection: $displayOptions.layout, label: Text("Layout")) {
                    ForEach(DisplayOptions.Layout.allCases.identified(by: \.self)) { layoutOption in
                        Text(layoutOption.rawValue).tag(layoutOption.self)
                    }
                }
                // "Sort by" picker
                Picker(selection: $displayOptions.sortBy, label: Text("Sort by")) {
                    ForEach(DisplayOptions.Sort.allCases.identified(by: \.self)) { sortBy in
                        Text(sortBy.rawValue).tag(sortBy.self)
                    }
                }
            }
            .navigationBarTitle(Text("displayOptions.title"))
            .navigationBarItems(trailing: Button(action: didTapDone) { Text("Done") })
        }
    }

    func didTapDone() {
        isPresented = false
    }

}

// MARK: - List

struct ComicsList: View {

    @ObjectBinding var viewModel: FetchedObjectsViewModel<ComicEntity>

    var body: some View {
        List {
            ForEach(viewModel.sections.identified(by: \.name)) { sectionInfo in
                ComicsSectionView(sectionInfo: sectionInfo)
            }
        }
    }

}

// MARK: - Grid

struct ComicsGrid: View {

    var body: some View {
        Text("Comic Grid")
    }

}

// MARK: - Carousel

struct ComicsCarousel: View {

    var body: some View {
        Text("Comic Carousel")
    }

}

// MARK: - Solicitations

struct SolicitationsView: View {

    @State var isPresentingDisplayOptions = false

    @State var displayOptions: DisplayOptions = .default

    var displayOptionsForm: Modal {
        Modal(DisplayOptionsForm(isPresented: $isPresentingDisplayOptions, displayOptions: $displayOptions), onDismiss: {
            self.isPresentingDisplayOptions = false
        })
    }

    var body: some View {
        NavigationView {
            Group {
                if displayOptions.layout == .list {
                    ComicsList(viewModel: DataController.shared.viewModel(for: displayOptions))
                }
                if displayOptions.layout == .grid {
                    ComicsGrid()
                }
                if displayOptions.layout == .carousel {
                    ComicsCarousel()
                }
            }
            .navigationBarTitle(Text("solicitations.title"))
            .navigationBarItems(trailing: HStack(spacing: .padding) {
                NavigationBarItem.filter(action: didTapFilter, systemImageName: displayOptions.filter.systemImageName)
                NavigationBarItem.displayOptions(action: didTapDisplayOptions)
            })
        }
        .presentation(isPresentingDisplayOptions ? displayOptionsForm : nil)
    }

    func didTapFilter() {
        if displayOptions.filter == .all {
            displayOptions.filter = .notPulled
        } else if displayOptions.filter == .notPulled {
            displayOptions.filter = .all
        }
    }

    func didTapDisplayOptions() {
        isPresentingDisplayOptions = true
    }

}

// MARK: - PullList

struct PullListView: View {

    var body: some View {
        NavigationView {
            Text("pullList.title")
                .navigationBarTitle(Text("pullList.title"))
                .navigationBarItems(trailing:
                    NavigationBarItem.displayOptions(action: didTapDisplayOptions)
                )
        }
    }

    func didTapDisplayOptions() {
        print("didTapDisplayOptions")
    }

}

// MARK: - Content

struct ContentView: View {

    @State private var selection: Int = 0

    var body: some View {
        TabbedView(selection: $selection) {
            SolicitationsView()
                .tabItem {
                    Image(systemName: "circle")
                    Text("solicitations.title")
                }
                .tag(0)
            PullListView()
                .tabItem {
                    Text("pullList.title")
                }
                .tag(1)
        }
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
