//
//  GamesListView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


import SwiftUI

struct GamesListView: View {
    @Bindable var viewModel: GamesListViewModel
    @Environment(DependencyContainer.self) private var container
    
    
    private var contentView: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading games…")
            } else {
                gamesList
            }
        }
    }
    
    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Games")
                .navigationDestination(item: $viewModel.route) { route in
                    DetailScreen(gameId: route.id)
                }
                .onSubmit(of: .search) {
                    Task { await viewModel.search() }
                }
                .onChange(of: viewModel.searchQuery) { _, newValue in
                    Task {
                        if newValue.isEmpty {
                            await viewModel.loadGames()
                        }
                    }
                }
        }
        .task {
            guard !viewModel.hasLoadedInitialGames else { return }
            await viewModel.loadGames()
        }
        .alert("Something went wrong", isPresented: errorBinding) {
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
                },
                onGameClicked: {
                    print("viewmodel notified ")
                    viewModel.onGameClicked(game)
                }
            )
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .compositingGroup()
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
    let onGameClicked: () -> Void
    
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
        Button {
            onGameClicked()
        } label: {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .bottomLeading) {
                        RemoteImageView(
                            url: game.backgroundImage ?? "https://placehold.co/600x400"
                        )
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)

                        LinearGradient(
                            colors: [.clear, .black.opacity(0.6)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(alignment: .bottomLeading) {
                gameInfo.padding()
            }
            .overlay(alignment: .topTrailing) {
                favouriteButton.padding(10)
            }
            .background(
                RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground))
            )
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        }
        .buttonStyle(.plain) 
        .accessibilityLabel(game.name)
        .accessibilityHint("Open game details")
    }
}
