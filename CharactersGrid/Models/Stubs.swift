//
//  Stubs.swift
//  CharactersGrid
//
//  Created by Wilson Leung on 2/3/2022.
//

import Foundation

extension Character {
    static let ff7Stubs: [Character] = {
        guard let items: [Character] = try? Bundle.main.loadAndDecodeJSON(filename: "ff7r", keyDecodingStrategy: .convertFromSnakeCase) else {
            return []
        }
        return items
    }()
    static let marvelStubs: [Character] = {
        guard let items: [Character] = try? Bundle.main.loadAndDecodeJSON(filename: "marvel", keyDecodingStrategy: .convertFromSnakeCase) else {
            return []
        }
        return items
    }()
    static let dcStubs: [Character] = {
        guard let items: [Character] = try? Bundle.main.loadAndDecodeJSON(filename: "dc", keyDecodingStrategy: .convertFromSnakeCase) else {
            return []
        }
        return items
    }()
    static let starWarsStubs: [Character] = {
        guard let items: [Character] = try? Bundle.main.loadAndDecodeJSON(filename: "starWars", keyDecodingStrategy: .convertFromSnakeCase) else {
            return []
        }
        return items
    }()
}

extension Bundle {
    func loadAndDecodeJSON<D: Decodable>(filename: String, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> D {
        guard let url = url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "", code: NSFileNoSuchFileError, userInfo: [NSLocalizedDescriptionKey: "File Not Found"])
        }
        let data = try Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = keyDecodingStrategy

        let decodedModel = try jsonDecoder.decode(D.self, from: data)
        return decodedModel
    }
}
