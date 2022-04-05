//
//  ExploreBannerViewModel.swift
//  TikTok
//
//  Created by Matias Correa Franco de Faria on 03/04/22.
//

import Foundation
import UIKit

struct ExploreBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)
}
