//
//  ViewExtenstion.swift
//  RAWGames
//
//  Created by Hardik Mehta on 03/04/26.
//

import NukeUI
import SwiftUI

func map(_ state: LazyImageState) -> ImageLoadState {
    if let image = state.image {
        return .success(image)
    } else if state.error != nil {
        return .failure
    } else {
        return .loading
    }
}

enum ImageLoadState {
    case loading
    case success(Image)
    case failure
}
