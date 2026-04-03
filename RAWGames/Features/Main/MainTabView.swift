//
//  MainTabView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//
import SwiftUI
import CoreData

struct MainTabView: View {
    @Environment(DependencyContainer.self) private var container
    
    var body: some View {
        TabView {
            GamesListView(
                viewModel: container.gamesListViewModel
            )
            .tabItem {
                Image(systemName: "house")
                Text("Games")
            }
            
            FavouritesView(
                viewModel: container.favouritesViewModel
            )
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            
            NotesView(
                viewModel: container.notesViewModel
            )
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Notes")
            }
        }
    }
}
