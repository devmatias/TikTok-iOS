//
//  ExploreHashTagViewModel.swift
//  TikTok
//
//  Created by Matias Correa Franco de Faria on 03/04/22.
//

import Foundation
import UIKit

struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int //number of posts associated with tag
    let handler: (() -> Void)
}
