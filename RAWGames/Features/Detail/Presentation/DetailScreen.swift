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
                if let vm = viewmodel, let game = vm.gameDetail {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 2) {
                            GameHeroSection(game: game)
                                .border(.cyan)
                            GameStatsSection(game: game)
                                .border(.red)
                            Spacer()
                                .frame(height: 24)
                            GameInfoView(gameDetail: game)
                        }
                    }.toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                viewmodel?.onFavouriteTapped()
                            }) {
                                Image(systemName: game.isFavourite == true ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                } else {
                    ProgressView()
                }
            }
        }.task {
            if viewmodel == nil {
                viewmodel = container.makeDetailViewModel(gameId: gameId)
                await viewmodel?.loadGameDetail()
            }
        }
    }
}






