//
//  PokemonDetailsDetailsView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 22/08/2024.
//

import SwiftUI

// TODO: Horrible naming, change this later
struct DetailsSectionView: View {
    let details: DetailedPokemon
    let viewModel: PokemonViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            PokemonDetailItemView(label: "Weight", value: "\(viewModel.formatHeightWeight(value: details.weight)) kg")
            PokemonDetailItemView(label: "Height", value: "\(viewModel.formatHeightWeight(value: details.height)) m")
        }
        .padding(.horizontal)
    }
}
