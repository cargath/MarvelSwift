//
//  URLImageView.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 27.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

extension View {

    /// Returns a type-erased version of the view.
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }

}

struct URLImageView: View {

    @ObjectBinding var viewModel: URLImageViewModel

    var body: some View {
        switch viewModel.image {
            case .placeholder:
                return Image(systemName: "photo.fill").onAppear(perform: appear)
            case .unavailable:
                return Image(systemName: "xmark.octagon.fill").onAppear()
            case let .remote(image):
                return Image(uiImage: image).onAppear()
            case let .cached(image):
                return Image(uiImage: image).onAppear()
        }
    }

    func appear() {
        viewModel.load()
    }

}
