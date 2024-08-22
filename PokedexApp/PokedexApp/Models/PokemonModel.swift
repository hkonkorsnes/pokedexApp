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

    static var samplePokemon = Pokemon(id: "151", name: "mew", url: "https://pokeapi.co/api/v2/pokemon/151/")

    init(id: String, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }

    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        id = UUID().uuidString
    }
}

struct DetailedPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let types: [PokemonType]
}

struct PokemonType: Codable {
    let slot: Int
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
    let url: String
}
