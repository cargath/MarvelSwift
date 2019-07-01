//
//  LazyView.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 01.07.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {

    let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }

}

#if DEBUG
struct LazyView_Previews : PreviewProvider {
    static var previews: some View {
        LazyView(Text("Hello World!"))
    }
}
#endif
