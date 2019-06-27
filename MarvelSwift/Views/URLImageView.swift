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
                return placeholder().eraseToAnyView()
            case let .remote(image):
                return remote(uiImage: image).eraseToAnyView()
            case .unavailable:
                return unavailable().eraseToAnyView()
        }
    }

    func placeholder() -> some View {
        ZStack {
            Color.gray
            Image(systemName: "photo.fill")
        }
    }

    func remote(uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
    }

    func unavailable() -> some View {
        ZStack {
            Color.gray
            Image(systemName: "xmark.octagon.fill")
        }
    }

}
