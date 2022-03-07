//
//  SectionCharacters.swift
//  CharactersGrid
//
//  Created by Wilson Leung on 2/3/2022.
//

import Foundation

struct SectionCharacters: Hashable, Equatable {
    let category: String
    let characters: [Character]

    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
    }

    static func ==(lhs: SectionCharacters, rhs: SectionCharacters) -> Bool {
        lhs.category == rhs.category
    }
}