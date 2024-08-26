//
//  RandomPokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 26/08/2024.
//

import Foundation
import SwiftUI

final class RandomPokemonViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    @Published var isShiny = false
    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetails: [String: DetailedPokemon] = [:] 

    init() {
        self.pokemonList = pokemonManager.fetchPokemon()
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
