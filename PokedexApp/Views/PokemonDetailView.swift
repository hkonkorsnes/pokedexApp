//
//  PokemonDetailView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct PokemonDetailView: View {

    @Environment(\.modelContext) private var context

    @EnvironmentObject var viewModel: PokemonViewModel
    
    let pokemon: Pokemon

    @State private var pokemonDetails: DetailedPokemon? = nil
    @State private var showError: Bool = false

    var body: some View {
        VStack {
            PokeDexView(pokemon: pokemon)

            if let details = pokemonDetails {
                VStack(alignment: .leading, spacing: 10) {
                    Text("**ID**: \(details.id)")
                    Text("**Weight**: \(viewModel.formatHeightWeight(value: details.weight)) kg")
                    Text("**Height**: \(viewModel.formatHeightWeight(value: details.height)) m")
                    Text("**Type**: \(details.types.map { $0.type.name.capitalized }.joined(separator: ", "))")
                }
                Spacer()
            } else if showError {
                // Displays error if details dont load
                Text("Failed to load details.")
            } else {
                // Displays Loading text when details are loading
                Text("Loading details...")
                    .onAppear {
                        viewModel.getDetails(pokemon: pokemon) { details in
                            if let details = details {
                                self.pokemonDetails = details
                            } else {
                                self.showError = true
                            }
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavoritePokemon(pokemon)
                    // Toggle the save state
                    addFavorite()
                }) {
                    Image(systemName: viewModel.isPokemonFavorited(pokemon) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isPokemonFavorited(pokemon) ? .red : .gray)
                }
            }
        }
    }

    func addFavorite() {
        let pokemon = Pokemon(id: "151", name: "Mew", url: "https://pokeapi.co/api/v2/pokemon/151/")
        context.insert(pokemon)
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon)
        .environmentObject(PokemonViewModel())
}
