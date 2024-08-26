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
        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }

    func onAppear() {
        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }
}
