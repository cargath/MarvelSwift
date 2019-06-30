//
//  NavigationBarItem.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 01.07.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

struct NavigationBarItem: View {

    let action: () -> Void

    @State var systemImageName: String

    @State var title: LocalizedStringKey

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: systemImageName)
                Text(title)
                    .font(.system(size: 10))
            }
        }
    }

}

extension NavigationBarItem {

    static func filter(action: @escaping () -> Void, systemImageName: String) -> NavigationBarItem {
        NavigationBarItem(action: action, systemImageName: systemImageName, title: "filter.title")
    }

    static func displayOptions(action: @escaping () -> Void) -> NavigationBarItem {
        NavigationBarItem(action: action, systemImageName: "list.bullet", title: "displayOptions.title")
    }

}

#if DEBUG
struct NavigationBarItem_Previews : PreviewProvider {
    static var previews: some View {
        NavigationBarItem(action: { print("action") }, systemImageName: "circle.fill", title: "Navigation")
    }
}
#endif
