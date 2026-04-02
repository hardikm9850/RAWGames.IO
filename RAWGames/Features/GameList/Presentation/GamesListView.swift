//
//  GamesListView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//


import SwiftUI

struct GamesListView: View {
    @State var viewModel : GamesListViewModel
    
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
        }
        .task {
            await viewModel.loadGames()
        }
        .alert("Something went wrong",
               isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
               ))
        {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var gamesList: some View {
        List(viewModel.games) { game in
            GameHeroCard(
                game: game,
                isFavourite: viewModel.favouriteIDs.contains(game.id),
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
    let isFavourite: Bool
    let onToggleFavourite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                
                RemoteImageView(url: game.backgroundImage
                                ?? "https://placehold.co/600x400")
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                
                LinearGradient(
                    colors: [.clear, .black.opacity(0.6)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                
                
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
                .padding()
                
                
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            onToggleFavourite()
                        } label: {
                            Image(systemName: isFavourite
                                  ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundStyle(isFavourite
                                             ? .red : .white)
                            .padding(10)
                            .background(.ultraThinMaterial,
                                        in: Circle())
                        }
                        .buttonStyle(.plain) 
                    }
                    Spacer()
                }
                .padding(10)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}


struct RemoteImageView: View {
    
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            
            switch phase {
                
            case .empty:
                ZStack {
                    Color.gray.opacity(0.2)
                    
                    ProgressView()
                }
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                
            case .failure:
                ZStack {
                    Color.gray.opacity(0.3)
                    
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                
            @unknown default:
                EmptyView()
            }
        }
    }
}
