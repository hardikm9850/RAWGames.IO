//
//  DetailScreen.swift
//  RAWGames
//
//  Created by Hardik Mehta on 09/04/26.
//

import SwiftUI

struct DetailScreen : View {
    @Environment(DependencyContainer.self) private var container
    @State var viewmodel: DetailViewModel?
    
    let gameId : Int
    
    var body: some View {
        ScrollView {
            Group {
                if let vm = viewmodel {
                    switch vm.state {
                    case .idle, .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 80)
                    case .failed(let errorMessage):
                        VStack(spacing: 16) {
                            Text(errorMessage)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)

                            Button("Retry") {
                                vm.retryLoadGameDetail()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 24)
                        .padding(.top, 80)
                    case .loaded(let game):
                        VStack(alignment: .leading, spacing: 2) {
                            GameHeroSection(game: game)
                            GameStatsSection(game: game)
                            Spacer()
                                .frame(height: 24)
                            GameInfoView(gameDetail: game)
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    viewmodel?.onFavouriteTapped()
                                }) {
                                    Image(systemName: game.isFavourite == true ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)
                }
            }
        }
        .task {
            if viewmodel == nil {
                viewmodel = container.makeDetailViewModel(gameId: gameId)
                await viewmodel?.loadGameDetail()
            }
        }
    }
}



