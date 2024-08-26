//
//  RandomPokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 26/08/2024.
//

import SwiftUI

final class RandomPokemonViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()

    @Published var randomPokemon: Pokemon?
    @Published var pokemonImageURL: String?
    @Published var pokemonList = [Pokemon]()
    
    @AppStorage("isShiny") var isShiny = false

    init() {
        self.pokemonList = pokemonManager.fetchPokemon()
        randomizePokemon()
    }

    // MARK: - Functions
    func fetchPokemonImageURL(id: String) -> String {
        isShiny
        ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(id).png"
        : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }

    func randomizePokemon() {
        guard let pokemon = pokemonList.randomElement() else { return }
        self.randomPokemon = pokemon
        self.pokemonImageURL = fetchPokemonImageURL(id: pokemon.id)
    }

    func loadRandomPokemon() {
        guard randomPokemon == nil else { return }
        randomizePokemon()
    }
}
