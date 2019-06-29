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

}

// Without manually casting to Length, .environment(\.defaultMinListHeaderHeight, .leastNonzeroMagnitude) doesn't get rid of the List separators.
extension Length {

    /// The least positive normal number.
    static var leastNormalMagnitude: Length { Length(Float.leastNormalMagnitude) }

    /// The least positive number.
    static var leastNonzeroMagnitude: Length { Length(Float.leastNonzeroMagnitude) }

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
