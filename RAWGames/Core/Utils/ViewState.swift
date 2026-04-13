//
//  LoadingState.swift
//  RAWGames
//
//  Created by Hardik Mehta on 10/04/26.
//

import Foundation

enum ViewState<Value: Equatable>: Equatable {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}
