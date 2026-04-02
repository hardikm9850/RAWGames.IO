//
//  HTTPClient.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL was malformed."
        case .invalidResponse(let code):
            return "Server returned status \(code)."
        case .noData:
            return "No data received."
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        }
    }
}

struct HTTPClient: Sendable {

    func get<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        do {
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            let decoder = JSONDecoder()
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
