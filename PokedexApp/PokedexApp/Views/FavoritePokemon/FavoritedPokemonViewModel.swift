//
//  FavoritedPokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 23/08/2024.
//

import SwiftUI

final class FavoritedPokemonViewModel: ObservableObject {
    @Published var favoritedPokemon: [Pokemon] = []
    @Published var isShiny = false

    private var store: FavoritePokemonStore

    init(favoritedPokemonStore: FavoritePokemonStore) {
        self.store = favoritedPokemonStore
        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }

    func fetchPokemonImageURL(id: String) -> String {
        isShiny
        ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(id).png"
        : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }

    func onAppear() {
        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }
}
