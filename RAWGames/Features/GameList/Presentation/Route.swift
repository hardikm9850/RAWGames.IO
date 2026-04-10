//
//  Route.swift
//  RAWGames
//
//  Created by Hardik Mehta on 09/04/26.
//


enum Route: Hashable, Identifiable {
    case detail(Int)

    var id: Int {
        switch self {
        case .detail(let id):
            return id
        }
    }
}
