//
//  UseCaseError.swift
//  RAWGames
//
//  Created by Hardik Mehta on 03/04/26.
//
import Foundation


enum UseCaseError: LocalizedError {
    case queryTooShort

    var errorDescription: String? {
        switch self {
        case .queryTooShort:
            return "Search query must be at least 2 characters."
        }
    }
}
