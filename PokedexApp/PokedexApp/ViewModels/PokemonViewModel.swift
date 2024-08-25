//
//  PokemonViewModel.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import Foundation
import SwiftUI

final class PokemonViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()

    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetails: [String: DetailedPokemon] = [:]  // Use String as the key type
    @Published var searchText = ""
    @Published var isShiny = false
    
    var filteredPokemon: [Pokemon] {
        return searchText.isEmpty ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }
    
    init() {
        self.pokemonList = pokemonManager.getPokemon()
    }
    
    func getPokemonIndex(pokemon: Pokemon) -> Int {
        return pokemonDetails[pokemon.id]?.id ?? 0  // Access by String id
    }
    
    func getDetails(pokemon: Pokemon, completion: @escaping (DetailedPokemon?) -> Void) {
        if let details = pokemonDetails[pokemon.id] {  // Access by String id
            completion(details)
            return
        }
        
        pokemonManager.getDetailedPokemon(url: pokemon.url) { data in
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
    
    func getSpecies(url: String, completion: @escaping (PokemonSpecies?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            if let species = try? decoder.decode(PokemonSpecies.self, from: data) {
                DispatchQueue.main.async {
                    completion(species)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func formatHeightWeight(value: Int) -> String {
        let dValue = Double(value)
        return String(format: "%.2f", dValue / 10)
    }
    
    // Connects Pokémon type to a color
    func color(forType type: String) -> Color {
        switch type.lowercased() {
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "grass":
            return Color.green
        case "electric":
            return Color.yellow
        case "psychic":
            return Color.purple
        case "ice":
            return Color.cyan
        case "dragon":
            return Color.orange
        case "dark":
            return Color.gray
        case "fairy":
            return Color.pink
        case "normal":
            return Color.brown
        default:
            return Color.gray
        }
    }
}
