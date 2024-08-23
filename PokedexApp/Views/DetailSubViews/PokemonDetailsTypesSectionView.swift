//
//  PokemonDetailsTypesSectionView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 22/08/2024.
//

import SwiftUI

struct PokemonDetailsTypesSectionView: View {
    let types: [PokemonType]
    let viewModel: PokemonViewModel
    
    var body: some View {
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
}
