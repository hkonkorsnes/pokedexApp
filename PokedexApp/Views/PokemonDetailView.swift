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
            PokemonView(pokemon: pokemon)
            
            HStack(alignment: .center, spacing: 10) {
                Text("**Number**: \n#\(viewModel.pokemonDetails?.id ?? 0)")
                Text("**Type**: \n\(viewModel.pokemonDetails?.types.map { $0.type.name.capitalized }.joined(separator: ", ") ?? "Unknown")")
                Text("**Height**: \n\(viewModel.formatHeightWeight(value: viewModel.pokemonDetails?.height ?? 0)) m")
                Text("**Weight**: \n\(viewModel.formatHeightWeight(value: viewModel.pokemonDetails?.weight ?? 0)) kg")
            }
            .padding()
        }
        .onAppear {
            viewModel.getDetails(pokemon: pokemon)
        }
        Spacer()
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon)
        .environmentObject(PokemonViewModel())
}
