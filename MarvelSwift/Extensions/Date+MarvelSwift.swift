//
//  Date+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 27.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Foundation

extension Date {

    func localizedString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        return DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
    }

    func localizedString(dateStyle: DateFormatter.Style) -> String {
        return localizedString(dateStyle: dateStyle, timeStyle: .none)
    }

    func localizedString(timeStyle: DateFormatter.Style) -> String {
        return localizedString(dateStyle: .none, timeStyle: timeStyle)
    }

}
