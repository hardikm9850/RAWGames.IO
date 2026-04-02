//
//  AppConfig.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//

import Foundation


enum AppConfig {
    
    static var apiKey: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "RAWG_API_KEY") as? String else {
            fatalError("Missing API Key")
        }
        return value
    }
}
