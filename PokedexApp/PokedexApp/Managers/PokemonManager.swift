//
//  PokemonManager.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import Foundation

final class PokemonManager {
    func getPokemon() -> [Pokemon] {
        let data: PokemonPage = Bundle.main.decode(file:"pokemon.json")
        let pokemon: [Pokemon] = data.results
        
        return pokemon
    }

    func getDetailedPokemon(url: URL, completion: @escaping (DetailedPokemon?) -> Void) {

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let detailedPokemon = try? decoder.decode(DetailedPokemon.self, from: data) {
                    completion(detailedPokemon)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
