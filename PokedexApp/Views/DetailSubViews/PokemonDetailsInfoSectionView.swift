//
//  PokemonDetailsInfoSectionView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 22/08/2024.
//

import SwiftUI

struct PokemonDetailsInfoSectionView: View {
    let pokemonName: String
    let infoText: String
    
    var body: some View {
        VStack {
            Text("Info about \(pokemonName.capitalized)")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Text(infoText)
                .font(.body)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}


#Preview {
    PokemonDetailsInfoSectionView(pokemonName: "Mew", infoText: "Test info")
}
