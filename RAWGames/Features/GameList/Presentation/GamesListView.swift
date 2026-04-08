//
//  GamesListView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


import SwiftUI
import NukeUI

struct GamesListView: View {
    @Bindable var viewModel: GamesListViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading games…")
                } else {
                    gamesList
                }
            }
            .navigationTitle("Games")
            .searchable(text: $viewModel.searchQuery)
            .onSubmit(of: .search) {
                Task { await viewModel.search() }
            }
            .onChange(of: viewModel.searchQuery) { old, newValue in
                Task {
                    if newValue.isEmpty {
                        await viewModel.loadGames()
                    }
                }
            }
        }
        .task {
            await viewModel.loadGames()
        }
        .alert("Something went wrong",
               isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
               )
        ){
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var gamesList: some View {
        List(viewModel.games) { game in
            GameHeroCard(
                game: game,
                onToggleFavourite: {
                    Task { await viewModel.toggleFavourite(game) }
                }
            )
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refresh()
        }
    }
}

struct GameHeroCard: View {
    let game: Game
    let onToggleFavourite: () -> Void
    
    
    private var gameInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(game.name)
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.green)
                
                Text(String(format: "%.1f", game.rating))
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
        }
    }
    
    private var favouriteButton: some View {
        Button {
            onToggleFavourite()
        } label: {
            Image(systemName: game.isFavorite ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(game.isFavorite ? .red : .white)
                .padding(10)
                .background(.ultraThinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // All children are stacked on top of each other
            // Default alignment = bottom-left
            ZStack(alignment: .bottomLeading) {
                
                RemoteImageView(url: game.backgroundImage
                                ?? "https://placehold.co/600x400")
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                
                LinearGradient(
                    colors: [.clear, .black.opacity(0.6)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(alignment: .bottomLeading) {
                gameInfo.padding()
            }
            .overlay(alignment: .topTrailing) {
                favouriteButton
                    .padding(10)
            }
            .background(Color(.systemBackground))
            .shadow(radius: 5)
        }
    }
}


struct RemoteImageView: View {
    let url: String
    
    var body: some View {
        LazyImage(url: URL(string: url)) { state in
            switch map(state) {
            case .loading:
                loadingView
            case .success(let image):
                image.resizable()
            case .failure:
                errorView
            }
        }
        .animation(.easeInOut, value: UUID())
    }
    
    private var loadingView: some View {
        ZStack {
            Color.gray.opacity(0.2)
            ProgressView()
        }
    }
    
    private var errorView: some View {
        ZStack {
            Color.gray.opacity(0.3)
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}
