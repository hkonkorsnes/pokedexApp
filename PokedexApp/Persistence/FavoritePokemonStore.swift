//
//  FavoritePokemonStore.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 23/08/2024.
//

import Foundation
import SwiftData

final class FavoritePokemonStore: ObservableObject {
    @Published var favorites = [Pokemon]()

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchPokemon()
    }

    // MARK: - Fetch

    func fetchPokemon() {
        let fetchRequest = FetchDescriptor<Pokemon>(sortBy: [SortDescriptor(\.name)])
        do {
            self.favorites = try modelContext.fetch(fetchRequest)
        } catch {
            print("Error fetching")
        }
    }

    // MARK: - Actions

    func save(pokemon: Pokemon) {
        do {
            modelContext.insert(pokemon)
            try modelContext.save()
            fetchPokemon()
        } catch {
            print("Error saving")
        }
    }

    func delete(pokemon: Pokemon) {
        do {
            modelContext.delete(pokemon)
            try modelContext.save()
            fetchPokemon()
        } catch {
            print("error deleting: \(error)")
        }
    }
}

