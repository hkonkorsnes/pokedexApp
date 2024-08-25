//
//  PokemonDetailView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI
import SwiftData

struct PokemonDetailView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @ObservedObject var viewModel: PokemonDetailViewModel

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
                        backgroundColor: pokemonViewModel.color(forType: details.types.first?.type.name ?? "unknown"),
                        imageUrl: getPokemonImageURL()
                    )

                    PokemonDetailsTypesSectionView(types: details.types, viewModel: pokemonViewModel)
                    PokemonDetailsInfoSectionView(pokemonName: pokemon.name, infoText: formatInfoText(infoText))
                    DetailsSectionView(details: details, viewModel: pokemonViewModel)
                } else {
                    ProgressView()
                }
                Spacer()
            }
        }
        .navigationTitle("\(pokemon.name.capitalized) #\(pokemon.id)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButton
            }
        }
        .onAppear {
            viewModel.onAppear()
            fetchPokemonDetails()
        }
    }

    // MARK: - Helper Functions
    private func getPokemonImageURL() -> String {
        let index = pokemonViewModel.getPokemonIndex(pokemon: pokemon)
        let baseUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        return pokemonViewModel.isShiny ? "\(baseUrl)shiny/\(index).png" : "\(baseUrl)\(index).png"
    }

    private func fetchPokemonDetails() {
        pokemonViewModel.getDetails(pokemon: pokemon) { details in
            if let details = details {
                self.pokemonDetails = details
                fetchPokemonSpecies(details.species.url)
            } else {
                self.showError = true
            }
        }
    }

    private func fetchPokemonSpecies(_ url: String) {
        pokemonViewModel.getSpecies(url: url) { species in
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
        }) {
            Image(systemName: viewModel.isPokemonFavorited(pokemon) ? "heart.fill" : "heart")
                .foregroundStyle(viewModel.isPokemonFavorited(pokemon) ? .red : .gray)
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pokemon.self, configurations: config)
    let pokemon = Pokemon.samplePokemon

    PokemonDetailView(
        viewModel: PokemonDetailViewModel(
            favoritedPokemonStore: FavoritePokemonStore(
                modelContext: ModelContext(container)
            )
        ), pokemon: Pokemon.samplePokemon
    )    
    .environmentObject(PokemonViewModel())
}
