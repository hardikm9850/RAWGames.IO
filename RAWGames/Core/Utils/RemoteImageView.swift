//
//  RemoteImageView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 09/04/26.
//
import SwiftUI
import NukeUI

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
