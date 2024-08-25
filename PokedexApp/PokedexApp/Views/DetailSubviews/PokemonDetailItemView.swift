//
//  PokemonDetailItemView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 22/08/2024.
//

import SwiftUI

struct PokemonDetailItemView: View {
    let label: String
    let value: String
    
    var body: some View {
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
}


#Preview {
    PokemonDetailItemView(label: "test", value: "50")
}
