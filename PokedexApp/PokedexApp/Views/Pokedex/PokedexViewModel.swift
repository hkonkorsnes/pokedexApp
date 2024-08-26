//
//  PokedexViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 26/08/2024.
//

import SwiftUI

class PokedexViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()

    @Published var pokemonList = [Pokemon]()
    @Published var searchText = ""

    @AppStorage("isShiny") var isShiny = false

    init() {
        self.pokemonList = pokemonManager.fetchPokemon()
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
