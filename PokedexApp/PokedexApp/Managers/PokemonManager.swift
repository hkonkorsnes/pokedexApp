//
//  PokemonManager.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import Foundation

class PokemonManager {
    func getPokemon() -> [Pokemon] {
        let data: PokemonPage = Bundle.main.decode(file:"pokemon.json")
        let pokemon: [Pokemon] = data.results
        
        return pokemon
    }
    
    func getDetailedPokemon(id: Int, _ completion:@escaping (DetailedPokemon) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/pokemon/\(id)/", model: DetailedPokemon.self) { data in
            completion(data)
            print(data)
            
        } failure: { error in
            print(error)
        }
    }
}
