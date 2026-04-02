//
//  GamesRepositoryImpl.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//


import Foundation

// actor — coordinates two non-thread-safe resources:
//   1. GamesCacheService  (wraps NSManagedObjectContext)
//   2. GamesAPIService    (stateless struct — but we control request deduplication here)
//
// Being an actor means only one fetch/write can execute at a time.
// No two Tasks can race to simultaneously write stale data over fresh data.

actor GamesRepositoryImpl: GamesRepository {

    private let apiService: GamesAPIService
    private let cacheService: GamesCacheService

    init(apiService: GamesAPIService,
         cacheService: GamesCacheService) {
        self.apiService = apiService
        self.cacheService = cacheService
    }

    // MARK: - GamesRepository

    func fetchGames(page: Int = 1) async throws -> [Game] {
        // ── Step 1: ask the cache ──────────────────────────────────────────
        // GamesCacheService is itself an actor — calling it here is an
        // actor-to-actor hop. 'await' is required even though it's fast.
        if let cached = try await cacheService.fetchCachedGames() {
            return cached   // cache hit — return immediately, no network call
        }

        // ── Step 2: cache miss — hit the network ──────────────────────────
        do {
            let games = try await apiService.fetchGames(page: page)

            // ── Step 3: write fresh data to cache ─────────────────────────
            // This is fire-and-write — we don't await the result because
            // the caller doesn't need to wait for the write to complete.
            // The user already has their data.
            try await cacheService.saveGames(games)

            return games

        } catch {
            // ── Step 4: network failed — try stale cache as fallback ───────
            // isCacheValid() checks for freshness. If cache exists but is
            // expired, we return it anyway — stale data beats no data.
            if let stale = try? await cacheService.fetchStaleGames() {
                return stale
            }
            // No cache at all and network failed — propagate the error
            throw error
        }
    }

    func fetchDetail(id: Int) async throws -> Game {
        // Detail pages always go to network — they need full description text
        // which isn't stored in the list cache.
        // In a full app you'd have a separate detail cache entity.
        try await apiService.fetchDetail(id: id)
    }

    func searchGames(query: String) async throws -> [Game] {
        // Search always hits the network — results are query-specific,
        // caching them would require a query-keyed cache (future improvement)
        try await apiService.searchGames(query: query)
    }

    func clearCache() async throws {
        try await cacheService.clearAll()
    }
}
