//
//  PokedexViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 25/08/2024.
//

import Foundation

final class PokedexViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()

    @Published var pokemonList = [Pokemon]()
    @Published var searchText = ""
    @Published var isShiny = false

    var filteredPokemon: [Pokemon] {
        return searchText.isEmpty ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }

    init() {
        Task {
            await loadPokemon()
        }
    }

    func loadPokemon() async {
        self.pokemonList = await pokemonManager.getPokemon()
    }
}
