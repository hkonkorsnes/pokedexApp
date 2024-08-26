//
//  PokemonCellViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 26/08/2024.
//

import SwiftUI

final class PokemonCellViewModel: ObservableObject {
    let pokemon: Pokemon
    private let pokemonManager = PokemonManager()

    @AppStorage("isShiny") var isShiny = false

    @Published var backgroundColor: Color = .gray
    @Published var detailedPokemon: DetailedPokemon?

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        fetchPokemonDetails()
    }

    func fetchPokemonDetails() {
        Task {
            let pokemonDetails = await pokemonManager.fetchDetailedPokemon(url: pokemon.url)
            DispatchQueue.main.async {
                self.detailedPokemon = pokemonDetails
                self.updateBackgroundColor()
            }
        }
    }

    func fetchPokemonImageURL(for pokemon: Pokemon) -> String {
        isShiny
        ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(pokemon.id).png"
        : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png"
    }

    func updateBackgroundColor() {
        guard let details = detailedPokemon else { return }
        if let primaryType = details.types.first?.type {
            backgroundColor = primaryType.color()
        } else {
            backgroundColor = .gray
        }
    }
}
