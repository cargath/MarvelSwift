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

    var placeholderImage: Image? {
        if case .placeholder = viewModel.image {
            return Image(systemName: "photo.fill")
        } else {
            return nil
        }
    }

    var unavailableImage: Image? {
        if case .unavailable = viewModel.image {
            return Image(systemName: "xmark.octagon.fill")
        } else {
            return nil
        }
    }

    var uiImage: Image? {
        switch viewModel.image {
            case let .remote(image):
                return Image(uiImage: image)
            case let .cached(image):
                return Image(uiImage: image)
            default:
                return nil
        }
    }

    var body: some View {
        ZStack {
            placeholderImage?.onAppear(perform: appear)
            unavailableImage
            uiImage?.resizable().mask(PageCurl(radius: 22))
        }
    }

    func appear() {
        viewModel.load()
    }

}

#if DEBUG
struct URLImageView_Previews : PreviewProvider {
    static var previews: some View {
        URLImageView(viewModel: URLImageViewModel(url: "".url!))
    }
}
#endif
