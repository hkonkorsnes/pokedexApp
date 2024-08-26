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

    func color(forType type: String) -> Color {
        switch type.lowercased() {
        case "normal":
            return Color.gray
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "grass":
            return Color.green
        case "ice":
            return Color.teal
        case "electric":
            return Color.yellow
        case "psychic":
            return Color.pink
        case "dragon":
            return Color.indigo
        case "poison":
            return Color.purple
        case "fighting":
            return Color.brown
        case "rock":
            return Color.brown
        case "flying":
            return Color.mint
        case "bug":
            return Color.green
        case "ghost":
            return Color.purple
        default:
            return Color.gray
        }
    }

    func updateBackgroundColor() {
        guard let details = detailedPokemon else { return }
        if let primaryType = details.types.first?.type.name {
            backgroundColor = color(forType: primaryType)
        } else {
            backgroundColor = .gray
        }
    }
}
