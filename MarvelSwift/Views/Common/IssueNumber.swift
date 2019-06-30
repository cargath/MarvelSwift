//
//  IssueNumber.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 01.07.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import SwiftUI

struct IssueNumber: View {

    @State var issueNumber: Int64

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("#")
                .font(.footnote)
                .fontWeight(.black)
                .color(.primary)
            Text("\(issueNumber)")
                .fontWeight(.black)
                .color(.primary)
        }
    }

}

#if DEBUG
struct IssueNumber_Previews : PreviewProvider {
    static var previews: some View {
        IssueNumber(issueNumber: 42)
    }
}
#endif
