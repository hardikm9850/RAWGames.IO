//
//  GameRowView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//

import SwiftUI

struct GameRowView: View {
    let game: Game
    let isFavourite: Bool
    let onToggleFavourite: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(game.name)
                    .font(.headline)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", game.rating))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if let released = game.released {
                        Text("· \(released)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
            Button {
                onToggleFavourite()
            } label: {
                Image(systemName: isFavourite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavourite ? .red : .secondary)
            }
            .buttonStyle(.plain)  // prevents List row tap from firing
        }
        .padding(.vertical, 4)
    }
}
