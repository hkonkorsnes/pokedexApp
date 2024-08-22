//
//  PokemonDexView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct PokeDexView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    let pokemon: Pokemon
    let dimensions: Double = 160
    @State private var backgroundColor: Color = .gray

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: getPokemonImageURL())) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: dimensions, height: dimensions)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                case .failure:
                    Image(systemName: "xmark.octagon.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .foregroundColor(.red)
                @unknown default:
                    Image(systemName: "questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .foregroundColor(.gray)
                }
            }
            Text("\(pokemon.name.capitalized)")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
                .padding(.bottom, 8)
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary, lineWidth: 2)
        )
        .padding(.horizontal)
        .onAppear {
            viewModel.getDetails(pokemon: pokemon) { details in
                if let primaryType = details?.types.first?.type.name {
                    self.backgroundColor = viewModel.color(forType: primaryType)
                } else {
                    self.backgroundColor = .gray
                }
            }
        }
    }

    private func getPokemonImageURL() -> String {
        return viewModel.isShiny
        ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(viewModel.getPokemonIndex(pokemon: pokemon)).png"
        : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(viewModel.getPokemonIndex(pokemon: pokemon)).png"
    }
}
