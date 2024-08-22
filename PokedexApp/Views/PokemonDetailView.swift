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
    @State private var pokemonSpecies: PokemonSpecies? = nil
    @State private var showError: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                if let details = pokemonDetails {
                    PokemonDetailHeaderView(
                        pokemon: pokemon,
                        backgroundColor: viewModel.color(forType: details.types.first?.type.name ?? "unknown"),
                        imageUrl: getPokemonImageURL()
                    )

                    PokemonDetailsTypesSectionView(types: details.types, viewModel: viewModel)
                    PokemonDetailsInfoSectionView(pokemonName: pokemon.name, infoText: formatInfoText(infoText))
                    DetailsSectionView(details: details, viewModel: viewModel)
                } else {
                    Text("Loading...")
                        .padding()
                }
                Spacer()
            }
            .onAppear(perform: fetchPokemonDetails)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButton
            }
        }
    }

    // MARK: - Helper Functions
    private func getPokemonImageURL() -> String {
        let index = viewModel.getPokemonIndex(pokemon: pokemon)
        let baseUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        return viewModel.isShiny ? "\(baseUrl)shiny/\(index).png" : "\(baseUrl)\(index).png"
    }

    private func fetchPokemonDetails() {
        viewModel.getDetails(pokemon: pokemon) { details in
            if let details = details {
                self.pokemonDetails = details
                fetchPokemonSpecies(details.species.url)
            } else {
                self.showError = true
            }
        }
    }

    private func fetchPokemonSpecies(_ url: String) {
        viewModel.getSpecies(url: url) { species in
            if let species = species {
                self.pokemonSpecies = species
            } else {
                self.showError = true
            }
        }
    }

    private func formatInfoText(_ text: String) -> String {
        text.replacingOccurrences(of: "\n", with: " ")
    }

    private var infoText: String {
        if let species = pokemonSpecies,
           let flavorText = species.flavorTextEntries.first(where: { $0.language.name == "en" }) {
            return flavorText.flavorText
        } else if showError {
            return "Failed to load information."
        } else {
            return "Loading information..."
        }
    }

    private var favoriteButton: some View {
        Button(action: {
            viewModel.toggleFavoritePokemon(pokemon)
            addFavorite()
        }) {
            Image(systemName: viewModel.isPokemonFavorited(pokemon) ? "heart.fill" : "heart")
                .foregroundColor(viewModel.isPokemonFavorited(pokemon) ? .red : .gray)
        }
    }

    private func addFavorite() {
        context.insert(pokemon)
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon)
        .environmentObject(PokemonViewModel())
}
