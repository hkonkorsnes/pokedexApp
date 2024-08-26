//
//  RandomPokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 26/08/2024.
//

import SwiftUI

class RandomPokemonViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()

    @Published var randomPokemon: Pokemon?
    @Published var pokemonImageURL: String?
    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetails: [String: DetailedPokemon] = [:]  // Use String as the key type
    
    @AppStorage("isShiny") var isShiny = false
    @AppStorage("randomPokemonID") private var randomPokemonID: String?

    init() {
        self.pokemonList = pokemonManager.fetchPokemon()
    }

    // MARK: - Functions
    func fetchPokemonImageURL(id: String) -> String {
        isShiny
        ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(id).png"
        : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }

    func randomizePokemon() {
        if let pokemon = pokemonList.randomElement() {
            fetchDetails(pokemon: pokemon) { _ in
                self.randomPokemon = pokemon
                self.randomPokemonID = pokemon.id  // Save the ID
                self.pokemonImageURL = self.fetchPokemonImageURL(id: pokemon.id)
            }
        }
    }

    func loadRandomPokemon() {
        if let randomPokemonID = randomPokemonID,
           let pokemon = pokemonList.first(where: { $0.id == randomPokemonID }) {
            self.randomPokemon = pokemon
            self.pokemonImageURL = fetchPokemonImageURL(id: pokemon.id)
        } else {
            randomizePokemon()
        }
    }
    
    func fetchDetails(pokemon: Pokemon, completion: @escaping (DetailedPokemon?) -> Void) {
        if let details = pokemonDetails[pokemon.id] {  // Access by String id
            completion(details)
            return
        }

        pokemonManager.fetchDetailedPokemon(url: pokemon.url) { data in
            DispatchQueue.main.async {
                if let data = data {
                    self.pokemonDetails[pokemon.id] = data  // Store using String id
                    completion(data)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
