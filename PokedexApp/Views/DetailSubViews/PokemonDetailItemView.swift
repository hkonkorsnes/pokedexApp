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
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}


#Preview {
    PokemonDetailItemView(label: "test", value: "50")
}
