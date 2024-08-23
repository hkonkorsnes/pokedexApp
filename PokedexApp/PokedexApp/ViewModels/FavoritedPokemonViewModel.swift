//
//  FavoritedPokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 23/08/2024.
//

import SwiftUI

final class FavoritedPokemonViewModel: ObservableObject {
    @Published var favoritedPokemon: [Pokemon] = []

    private var store: FavoritePokemonStore

    init(favoritedPokemonStore: FavoritePokemonStore) {
        self.store = favoritedPokemonStore
    }

    func onAppear() {
        store.fetchPokemon()
        favoritedPokemon = store.pokemon
    }

    func addFavorite(pokemon: Pokemon) {
        store.save(pokemon: pokemon)
        favoritedPokemon = store.pokemon
    }

    func toggleFavoritePokemon(_ pokemon: Pokemon) {
        if store.pokemon.contains(pokemon) {
            store.delete(pokemon: pokemon)
        } else {
            store.save(pokemon: pokemon)
        }

        store.fetchPokemon()
        favoritedPokemon = store.pokemon
    }

    func isPokemonFavorited(_ pokemon: Pokemon) -> Bool {
        return store.pokemon.contains(pokemon)
    }
}
