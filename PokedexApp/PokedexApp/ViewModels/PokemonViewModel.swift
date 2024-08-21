//
//  PokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import Foundation
import SwiftUI

class PokemonViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    
    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetails: DetailedPokemon?
    @Published var searchText = ""
    @Published var isShiny = false
    @Published var favoritedPokemon: [Pokemon] = []

    var filteredPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }
    
    init() {
        self.pokemonList = pokemonManager.getPokemon()
    }
    
    func getPokemonIndex(pokemon: Pokemon) -> Int {
        if let index = self.pokemonList.firstIndex(of: pokemon) {
            return index + 1
        }
        return 0
    }
    
    func getDetails(pokemon: Pokemon) {
        let id = getPokemonIndex(pokemon: pokemon)
        
        self.pokemonDetails = DetailedPokemon(id: 0, height: 0, weight: 0, types: [])
        
        pokemonManager.getDetailedPokemon(id: id) { data in
            DispatchQueue.main.async {
                self.pokemonDetails = data
            }
        }
    }
    
    func formatHeightWeight(value: Int) -> String {
        let dValue = Double(value)
        let string = String(format: "%.2f", dValue / 10)
        
        return string
    }

        func toggleFavoritePokemon(_ pokemon: Pokemon) {
            if let index = favoritedPokemon.firstIndex(of: pokemon) {
                favoritedPokemon.remove(at: index) //Remove pokemon if its already favorited
            } else {
                favoritedPokemon.append(pokemon) // If not, favorite it
            }
        }

        func isPokemonFavorited(_ pokemon: Pokemon) -> Bool {
            return favoritedPokemon.contains(pokemon)
        }

}
