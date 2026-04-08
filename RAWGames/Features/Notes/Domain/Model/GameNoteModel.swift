//
//  GameNoteModel.swift
//  RAWGames
//
//  Created by Hardik Mehta on 02/04/26.
//
import Foundation


struct GameNoteModel: Identifiable {
    let id: UUID
    let title: String
    let content: String
    let createdAt: Date
    let updatedAt: Date
}
