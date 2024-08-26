//
//  Pokemon.swift
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
final class Pokemon: Decodable, Identifiable, Equatable {
    @Attribute(.unique)
    var id: String
    var name: String
    var url: URL

    static var samplePokemon = Pokemon(
        id: "151",
        name: "Mew",
        url: URL(string: "https://pokeapi.co/api/v2/pokemon/151/")!
    )

    init(id: String, name: String, url: URL) {
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
        let url = try container.decode(URL.self, forKey: .url)

        self.name = try container.decode(String.self, forKey: .name)
        self.url = url
        // Workaround to provide a stable identifier since the list API does not return an id.
        self.id = url.pathComponents.last ?? "0"
    }

    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.url == rhs.url
    }
}

struct DetailedPokemon: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let species: Species

    struct Species: Codable {
        let name: String
        let url: URL
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
