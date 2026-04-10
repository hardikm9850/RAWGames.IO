//
//  GameInfoView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 10/04/26.
//
import SwiftUI

struct GameInfoView: View {
    let gameDetail: GameDetail?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Grid(alignment: .topLeading, horizontalSpacing: 16, verticalSpacing: 16) {

                // Row 1: Platforms + Genres
                let platforms = gameDetail?.platforms.compactMap({ $0 }).joined(separator: ", ") ?? ""
                let genres = gameDetail?.genres.compactMap({ $0 }).joined(separator: ", ") ?? ""

                if !platforms.isEmpty || !genres.isEmpty {
                    GridRow {
                        if !platforms.isEmpty {
                            InfoGridItem(title: "Platforms", value: platforms)
                        } else {
                            Color.clear
                        }
                        if !genres.isEmpty {
                            InfoGridItem(title: "Genres", value: genres)
                        } else {
                            Color.clear
                        }
                    }
                }

                
                let releaseDate = gameDetail?.released ?? ""
                let developers = gameDetail?.developers.compactMap({ $0 }).joined(separator: ", ") ?? ""

                if !releaseDate.isEmpty || !developers.isEmpty {
                    GridRow {
                        if !releaseDate.isEmpty {
                            InfoGridItem(title: "Release Date", value: releaseDate)
                        } else {
                            Color.clear
                        }
                        if !developers.isEmpty {
                            InfoGridItem(title: "Developers", value: developers)
                        } else {
                            Color.clear
                        }
                    }
                }

                // Row 3: Publishers (full width)
                if let publishers = gameDetail?.publishers.compactMap({ $0 }).joined(separator: ", "),
                   !publishers.isEmpty {
                    GridRow {
                        InfoGridItem(title: "Publishers", value: publishers)
                            .gridCellColumns(2)
                    }
                }
            }

            if let website = gameDetail?.website, !website.isEmpty {
                InfoGridItem(title: "Website", value: website, isLink: true)
            }
        }
        .padding(.horizontal, 16)
    }
}
