//
//  PokemonModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import Foundation
import SwiftData

struct PokemonPage: Decodable {
    let count: Int
    let next: String
    let results: [Pokemon]
}

@Model
class Pokemon: Decodable, Identifiable, Equatable {
    var id: String
    var name: String
    var url: String

    static var samplePokemon = Pokemon(id: "151", name: "Mew", url: "https://pokeapi.co/api/v2/pokemon/151/")

    init(id: String, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }

    enum CodingKeys: String, CodingKey {
        case name
        case url
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        self.id = UUID().uuidString
    }

    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.url == rhs.url
    }
}

struct DetailedPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let species: Species

    struct Species: Codable {
        let name: String
        let url: String
    }
}

struct PokemonType: Codable {
    let slot: Int
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
    let url: String
}

// MARK: - Structures for Species Data
struct PokemonSpecies: Codable {
    let flavorTextEntries: [FlavorTextEntry]

    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
    }
}

struct FlavorTextEntry: Codable {
    let flavorText: String
    let language: Language

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
}

struct Language: Codable {
    let name: String
}
