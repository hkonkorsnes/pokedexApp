//
//  PokedexViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 26/08/2024.
//

import SwiftUI

final class PokedexViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    private(set) var pokemonDetails: [String: DetailedPokemon] = [:]

    @Published var pokemonList = [Pokemon]()
    @Published var searchText = ""

    @AppStorage("isShiny") var isShiny = false

    init() {
        self.pokemonList = pokemonManager.fetchPokemon()
    }

    func fetchAllPokemonDetails() {
        for pokemon in pokemonList {
            pokemonManager.fetchDetailedPokemon(
                url: pokemon.url) { detailedPokemon in
                    if let detailedPokemon {
                        self.pokemonDetails[pokemon.id] = detailedPokemon
                    }
                }
        }
    }

    func getDetails(for pokemon: Pokemon) -> DetailedPokemon? {
        return pokemonDetails[pokemon.id]
    }

    func color(forType type: String) -> Color {
        switch type.lowercased() {
        case "normal":
            return Color.gray
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "grass":
            return Color.green
        case "ice":
            return Color.teal
        case "electric":
            return Color.yellow
        case "psychic":
            return Color.pink
        case "dragon":
            return Color.indigo
        case "poison":
            return Color.purple
        case "fighting":
            return Color.brown
        case "rock":
            return Color.brown
        case "flying":
            return Color.mint
        case "bug":
            return Color.green
        case "ghost":
            return Color.purple
        default:
            return Color.gray
        }
    }

    var filteredPokemon: [Pokemon] {
        return searchText.isEmpty ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }

    func fetchPokemonImageURL(for pokemon: Pokemon) -> String {
        isShiny
        ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(pokemon.id).png"
        : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png"
    }
}
