//
//  ExplorePostViewModel.swift
//  TikTok
//
//  Created by Matias Correa Franco de Faria on 03/04/22.
//

import Foundation
import UIKit

struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}
