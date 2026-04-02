//
//  FavouritesView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//


import SwiftUI

struct FavouritesView: View {
    @State var viewModel: FavouritesViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favourites.isEmpty {
                    emptyState
                } else {
                    favouritesList
                }
            }
            .navigationTitle("Favourites")
        }
        .task {
            await viewModel.loadFavourites()
            
        }
    }
    
    private var favouritesList: some View {
        List {
            ForEach(viewModel.favourites) { game in
                GameRowView(game: game,
                            isFavourite: viewModel.favouriteIDs.contains(game.id),
                            onToggleFavourite: {
                    Task {
                        await viewModel.toggleFavourite(game)
                    }
                })
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        Task { await viewModel.remove(game) }
                    } label: {
                        Label("Remove", systemImage: "heart.slash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var emptyState: some View {
        ContentUnavailableView(
            "No favourites yet",
            systemImage: "heart",
            description: Text("Games you favourite will appear here")
        )
    }
}
