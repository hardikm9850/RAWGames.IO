//
//  InfoGridItem.swift
//  RAWGames
//
//  Created by Hardik Mehta on 10/04/26.
//
import SwiftUI

struct InfoGridItem: View {
    let title: String
    let value: String
    var isLink: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.gray)
            
            if isLink, let linkURL = URL(string: value) {
                Link(destination: linkURL) {
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            } else {
                Text(value)
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
