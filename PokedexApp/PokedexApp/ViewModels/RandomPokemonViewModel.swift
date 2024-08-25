//
//  RandomPokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 25/08/2024.
//

import Foundation

final class RandomPokemonViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()

    @Published var randomPokemon: Pokemon?
    @Published var pokemonImageURL: String?

    func randomizePokemon() async {
        guard let pokemon = await pokemonManager.getPokemon().randomElement() else { return }
        self.randomPokemon = pokemon
        self.pokemonImageURL = getPokemonImageURL(for: pokemon)
    }

    private func getPokemonImageURL(for pokemon: Pokemon) -> String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png"
    }
}
