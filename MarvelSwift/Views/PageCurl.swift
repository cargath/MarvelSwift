//
//  PageCurl.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 29.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

struct PageCurl: View {

    @State var radius: Length

    var body: some View {
        ZStack {
            Color.black.relativeWidth(1).padding(.trailing, radius * 0.66 + radius * 0.5)
            Color.black.relativeHeight(1).padding(.bottom, radius * 0.66 + radius * 0.5)
            Color.black.relativeSize(width: 1, height: 1).padding([.bottom, .trailing], radius * 0.7)
            HStack {
                Spacer()
                Capsule()
                    .fill(Color.black)
                    .frame(width: radius)
                    .padding(.bottom, radius * 0.66)
            }
            VStack {
                Spacer()
                Capsule()
                    .fill(Color.black)
                    .frame(height: radius)
                    .padding(.trailing, radius * 0.66)
            }
        }
    }

}

#if DEBUG
struct PageCurl_Previews : PreviewProvider {
    static var previews: some View {
        PageCurl(radius: 33)
    }
}
#endif
