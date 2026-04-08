//
//  NotesView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 01/04/26.
//

import SwiftUI
import Foundation

struct NotesView: View {
    @Bindable var viewModel : NotesViewModel
    
    @State private var showAddNote = false
    
    var body: some View {
        ZStack {
            
            // MARK: - Content
            if viewModel.notes.isEmpty {
                emptyStateView
            } else {
                notesList
            }
            
            // MARK: - Floating Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    addButton
                }
            }
            .padding()
        }
        .navigationTitle("Notes")
        .task {
            await viewModel.loadNotes()
        }
        .sheet(isPresented: $showAddNote) {
            AddNoteView { title, content in
                Task {
                    await viewModel.addNote(
                        title: title,
                        content: content
                    )
                }
            }
        }
    }
}

private extension NotesView {
    
    var notesList: some View {
        List {
            ForEach(viewModel.notes) { note in
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(note.title)
                        .font(.headline)
                    
                    Text(note.content)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    Text(note.createdAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .onDelete { indexSet in
                let notesToDelete = indexSet.map { index in
                    viewModel.notes[index].id
                }
                Task { // ensures deletions happen sequentially within a single task
                    for id in notesToDelete {
                        await viewModel.deleteNote(id: id)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

private extension NotesView {
    
    var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "note.text")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Notes Yet")
                .font(.headline)
            
            Text("Tap + to add your first note")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

private extension NotesView {
    
    var addButton: some View {
        Button {
            showAddNote = true
        } label: {
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
}

