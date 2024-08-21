//
//  PokemonModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import Foundation

struct PokemonPage: Codable {
    let count: Int
    let next: String
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: String
    
    static var samplePokemon = Pokemon(name: "gyarados", url: "https://pokeapi.co/api/v2/pokemon/shiny/130/")
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
