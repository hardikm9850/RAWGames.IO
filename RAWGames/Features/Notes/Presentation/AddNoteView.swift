//
//  AddNoteView.swift
//  RAWGames
//
//  Created by Hardik Mehta on 02/04/26.
//
import SwiftUI

struct AddNoteView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    
    let onSave: (String, String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                TextField("Game Title", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                TextEditor(text: $content)
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Note")
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title, content)
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}
