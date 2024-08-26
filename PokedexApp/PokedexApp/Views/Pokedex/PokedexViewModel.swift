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

    func getDetails(for pokemon: Pokemon) -> DetailedPokemon? {
        return pokemonDetails[pokemon.id]
    }

    var filteredPokemon: [Pokemon] {
        return searchText.isEmpty ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }
}
