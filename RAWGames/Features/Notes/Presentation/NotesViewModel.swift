//
//  NotesViewModel.swift
//  RAWGames
//
//  Created by Hardik Mehta on 02/04/26.
//

import Foundation

@Observable
@MainActor
final class NotesViewModel{
    
    private let repository: GameNoteRepository
    
    var notes: [GameNoteModel] = []
    var isLoading = false
    var errorMessage: String?
    
    init(repository: GameNoteRepository) {
        self.repository = repository
    }
    
    func loadNotes() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            notes = try await repository.getAllNotes()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func addNote(title: String, content: String) async {
        errorMessage = nil
        let note = GameNoteModel(
            id: UUID(),
            title: title,
            content: content,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        do {
            try await repository.save(note: note)
            await loadNotes()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteNote(id: UUID) async {
        errorMessage = nil
        do {
            try await repository.delete(noteId: id)
            notes.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
