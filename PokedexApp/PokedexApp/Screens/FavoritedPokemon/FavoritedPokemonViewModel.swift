//
//  FavoritedPokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 23/08/2024.
//

import SwiftUI

final class FavoritedPokemonViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()

    @Published var pokemonList = [Pokemon]()
    @Published var favoritedPokemon: [Pokemon] = []
    @Published var pokemonDetails: [String: DetailedPokemon] = [:]  // Use String as the key type

    private var store: FavoritePokemonStore

    init(favoritedPokemonStore: FavoritePokemonStore) {
        self.store = favoritedPokemonStore
        self.pokemonList = pokemonManager.fetchPokemon()
    }

    func onAppear() {
        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }

    func fetchPokemonIndex(pokemon: Pokemon) -> Int {
        return pokemonDetails[pokemon.id]?.id ?? 0  // Access by String id
    }
}
