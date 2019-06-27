//
//  URLImage.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 27.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import UIKit

enum URLImage {

    case placeholder
    case unavailable
    case remote(_ image: UIImage)
    case cached(_ image: UIImage)

}
