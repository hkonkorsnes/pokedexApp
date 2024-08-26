//
//  PokemonManager.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import Foundation

final class PokemonManager {
    func fetchPokemon() -> [Pokemon] {
        let data: PokemonPage = Bundle.main.decode(file:"pokemon.json")
        let pokemon: [Pokemon] = data.results
        
        return pokemon
    }

    func fetchDetailedPokemon(url: URL) async -> DetailedPokemon? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let detailedPokemon = try JSONDecoder().decode(DetailedPokemon.self, from: data)
            print(String(data: data, encoding: .utf8))
            return detailedPokemon
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchSpecies(url: URL) async -> PokemonSpecies? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data.formattedJSON)
            let pokemonSpecies = try JSONDecoder().decode(PokemonSpecies.self, from: data)
            return pokemonSpecies
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

private extension Data {
    var formattedJSON: String {
        guard let object = try? JSONSerialization.jsonObject(with: self),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let formattedString = String(data: data, encoding: .utf8) else { return "Failed to string format JSON" }
        return formattedString
    }
}
