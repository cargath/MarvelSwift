//
//  CoverImage.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 30.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

struct CoverPage: View {

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            Rectangle()
                .stroke(Color.gray)
        }
    }

}

struct CoverImage: View {

    @State var numberOfPages: Int = 3

    @State var pageDepth: Int = 2

    @State var url: URL

    var body: some View {
        ZStack {
            ForEach((0 ... numberOfPages).reversed()) { i in
                CoverPage()
                    .offset(CGSize(width: i * self.pageDepth, height: i * self.pageDepth))
            }
            URLImageView(viewModel: URLImageViewModel(url: url))
        }
        .padding([.bottom, .trailing], Length(numberOfPages * pageDepth))
    }

}

#if DEBUG
struct CoverImage_Previews : PreviewProvider {
    static var previews: some View {
        CoverImage(url: URL(string: "")!)
    }
}
#endif
