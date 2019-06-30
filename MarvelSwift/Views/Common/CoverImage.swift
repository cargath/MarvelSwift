//
//  CoverImage.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 30.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

struct CoverImage: View {

    enum Style {
        case stroke
        case fill
        case shadow
    }

    @State var url: URL

    @State var style: Style = .shadow

    var numberOfPages: Int {
        switch style {
            case .stroke:
                return 3
            case .fill:
                return 2
            case .shadow:
                return 4
        }
    }

    var pageDepth: Int {
        switch style {
            case .stroke:
                return 2
            case .fill:
                return 2
            case .shadow:
                return 1
        }
    }

    var body: some View {
        ZStack {
            ForEach((0 ... numberOfPages).reversed()) { i in
                self.page(i)
                    .offset(CGSize(width: i * self.pageDepth, height: i * self.pageDepth))
            }
            Rectangle()
                .fill(Color.white)
            URLImageView(viewModel: URLImageViewModel(url: url))
        }
        .padding([.bottom, .trailing], Length(numberOfPages * pageDepth))
    }

    func page(_ i: Int) -> some View {
        ZStack {
            if self.style == .stroke {
                Rectangle()
                    .fill(Color.white)
                Rectangle()
                    .stroke(Color.gray)
            }
            if self.style == .fill {
                Rectangle()
                    .fill(Color.gray)
            }
            if self.style == .shadow {
                Rectangle()
                    .fill(Color(white: Double(i) / Double(self.numberOfPages) - 0.1))
            }
        }
    }

}

#if DEBUG
struct CoverImage_Previews : PreviewProvider {
    static var previews: some View {
        CoverImage(url: URL(string: "")!)
    }
}
#endif
