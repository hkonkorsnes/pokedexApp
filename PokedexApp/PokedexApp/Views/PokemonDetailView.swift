//
//  PokemonDetailView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    let pokemon: Pokemon

    var body: some View {
        VStack {
            PokeDexView(pokemon: pokemon)

            VStack(alignment: .leading, spacing: 10) {
                Text("**ID**: \(viewModel.pokemonDetails?.id ?? 0)")
                Text("**Weight**: \(viewModel.formatHeightWeight(value: viewModel.pokemonDetails?.weight ?? 0)) kg")
                Text("**Height**: \(viewModel.formatHeightWeight(value: viewModel.pokemonDetails?.height ?? 0)) m")
                Text("**Type**: \(viewModel.pokemonDetails?.types.map { $0.type.name.capitalized }.joined(separator: ", ") ?? "Unknown")")
            }

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavoritePokemon(pokemon)
                }) {
                    Image(systemName: viewModel.isPokemonFavorited(pokemon) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isPokemonFavorited(pokemon) ? .red : .gray)
                }
            }
        }
        .onAppear {
            viewModel.getDetails(pokemon: pokemon)
        }
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon)
        .environmentObject(PokemonViewModel())
}
