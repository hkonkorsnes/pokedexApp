//
//  PokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import Foundation
import SwiftUI

class PokemonViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()

    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetails: [String: DetailedPokemon] = [:]  // Use String as the key type
    @Published var searchText = ""
    @Published var isShiny = false
    @Published var favoritedPokemon: [Pokemon] = []

    var filteredPokemon: [Pokemon] {
        return searchText.isEmpty ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }

    init() {
        self.pokemonList = pokemonManager.getPokemon()
    }

    func getPokemonIndex(pokemon: Pokemon) -> Int {
        return pokemonDetails[pokemon.id]?.id ?? 0  // Access by String id
    }

    func getDetails(pokemon: Pokemon, completion: @escaping (DetailedPokemon?) -> Void) {
        if let details = pokemonDetails[pokemon.id] {  // Access by String id
            completion(details)
            return
        }

        pokemonManager.getDetailedPokemon(url: pokemon.url) { data in
            DispatchQueue.main.async {
                if let data = data {
                    self.pokemonDetails[pokemon.id] = data  // Store using String id
                    completion(data)
                } else {
                    completion(nil)
                }
            }
        }
    }

    func formatHeightWeight(value: Int) -> String {
        let dValue = Double(value)
        return String(format: "%.2f", dValue / 10)
    }

    func toggleFavoritePokemon(_ pokemon: Pokemon) {
        if let index = favoritedPokemon.firstIndex(of: pokemon) {
            favoritedPokemon.remove(at: index)  // Remove Pokémon if it's already favorited
        } else {
            favoritedPokemon.append(pokemon)  // If not, favorite it
        }
    }

    func isPokemonFavorited(_ pokemon: Pokemon) -> Bool {
        return favoritedPokemon.contains(pokemon)
    }

    // Connects Pokémon type to a color
    func color(forType type: String) -> Color {
        switch type.lowercased() {
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "grass":
            return Color.green
        case "electric":
            return Color.yellow
        case "psychic":
            return Color.purple
        case "ice":
            return Color.cyan
        case "dragon":
            return Color.orange
        case "dark":
            return Color.gray
        case "fairy":
            return Color.pink
        case "normal":
            return Color.brown
        default:
            return Color.gray
        }
    }
}
