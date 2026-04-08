//
//  APIEndpoint.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


import Foundation

enum GameRoute {
    private static let base = "https://api.rawg.io/api"
    private static let apiKey = AppConfig.apiKey
    
    
    case games(page: Int)
    case gameDetail(id: Int)
    case searchGames(query: String)

    var url: URL? {
        var components = URLComponents(string: GameRoute.base + path)
        let token = queryItems + [URLQueryItem(name: "key", value: GameRoute.apiKey)]
        components?.queryItems = token
        return components?.url
    }

    // Decides the endpoint
    private var path: String {
        switch self {
        case .games:             return "/games"
        case .gameDetail(let id): return "/games/\(id)"
        case .searchGames:       return "/games"
        }
    }
    
    // Decides query params
    private var queryItems: [URLQueryItem] {
        switch self {
        case .games(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .gameDetail:
            return []
        case .searchGames(let query):
            return [URLQueryItem(name: "search", value: query)]
        }
    }
}
