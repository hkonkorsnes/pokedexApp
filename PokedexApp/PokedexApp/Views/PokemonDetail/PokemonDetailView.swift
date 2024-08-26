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
    @ObservedObject var viewModel: PokemonDetailViewModel

    var body: some View {
        ScrollView {
            VStack {
                if let details = viewModel.pokemonDetails {
                    PokemonDetailHeaderView(
                        pokemon: viewModel.pokemon,
                        backgroundColor: viewModel.color(forType: details.types.first?.type.name ?? "unknown"),
                        imageUrl: viewModel.fetchPokemonImageURL()
                    )
                    typesSection(types: details.types)
                    infoSection
                    detailsSection(details: details)
//                    DetailsSectionView(details: details, viewModel: pokemonViewModel)
                } else {
                    ProgressView()
                }
                Spacer()
            }
        }
        .navigationTitle("\(viewModel.pokemon.name.capitalized) #\(viewModel.pokemon.id)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButton
            }
        }
        .onAppear {
            viewModel.onAppear()
            viewModel.fetchPokemonDetails()
        }
    }

    private func typesSection(types: [PokemonType]) -> some View {
        HStack {
            ForEach(types, id: \.type.name) { typeInfo in
                Text(typeInfo.type.name.capitalized)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(viewModel.color(forType: typeInfo.type.name).opacity(0.2))
                    .foregroundStyle(viewModel.color(forType: typeInfo.type.name))
                    .cornerRadius(20)
            }
        }
        .padding(.bottom, 10)
    }

    private var infoSection: some View {
        VStack {
            Text("Info about \(viewModel.pokemon.name.capitalized)")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Text(formatInfoText(infoText))
                .font(.body)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }

    private func detailsSection(details: DetailedPokemon) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            detailItem(label: "Weight", value: "\(viewModel.formatHeightWeight(value: details.weight)) kg")
            detailItem(label: "Height", value: "\(viewModel.formatHeightWeight(value: details.height)) m")
        }
        .padding(.horizontal)
    }

    private func detailItem(label: String, value: String) -> some View {
        VStack(alignment: .center) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.gray)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .clipShape(.capsule)
    }

    

    // MARK: - Helper Functions
    private func formatInfoText(_ text: String) -> String {
        text.replacingOccurrences(of: "\n", with: " ")
    }

    private var infoText: String {
        if let species = viewModel.pokemonSpecies,
           let flavorText = species.flavorTextEntries.first(where: { $0.language.name == "en" }) {
            return flavorText.flavorText
        } else if viewModel.showError {
            return "Failed to load information."
        } else {
            return "Loading information..."
        }
    }

    private var favoriteButton: some View {
        Button(action: {
            viewModel.toggleFavoritePokemon(viewModel.pokemon)
        }) {
            Image(systemName: viewModel.isPokemonFavorited(viewModel.pokemon) ? "heart.fill" : "heart")
                .foregroundStyle(viewModel.isPokemonFavorited(viewModel.pokemon) ? .red : .gray)
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pokemon.self, configurations: config)
    let pokemon = Pokemon.samplePokemon

    PokemonDetailView(
        viewModel: PokemonDetailViewModel(
            pokemon: .samplePokemon,
            favoritedPokemonStore: FavoritePokemonStore(
                modelContext: ModelContext(container)
            )
        )
    )   
}
