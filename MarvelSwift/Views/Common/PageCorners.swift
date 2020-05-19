//
//  PageCorners.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 05.07.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

struct PageCorners: View {

    @State var radius: Length

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
            HStack {
                Spacer()
                Rectangle()
            }
        }
    }

}

#if DEBUG
struct PageCorners_Previews : PreviewProvider {
    static var previews: some View {
        PageCorners(radius: 33)
    }
}
#endif
