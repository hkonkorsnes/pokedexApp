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
                        .shadow(radius: 10)
                case .failure:
                    Image(systemName: "xmark.octagon.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .foregroundColor(.red)
                        .shadow(radius: 10)
                @unknown default:
                    Image(systemName: "questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .foregroundColor(.gray)
                        .shadow(radius: 10)
                }
            }
            Text("\(pokemon.name.capitalized)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 8)
        }
        .background(LinearGradient(gradient: Gradient(colors: [backgroundColor.opacity(0.8), backgroundColor.opacity(0.5)]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.7), lineWidth: 2)
        )
        .shadow(color: backgroundColor.opacity(0.6), radius: 10, x: 0, y: 5)
        .onAppear {
            viewModel.getDetails(pokemon: pokemon) { details in
                if let primaryType = details?.types.first?.type.name {
                    self.backgroundColor = viewModel.color(forType: primaryType)
                } else {
                    self.backgroundColor = .gray
                }
            }
        }
        .padding(.horizontal)

    }

    private func getPokemonImageURL() -> String {
        return viewModel.isShiny
        ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(viewModel.getPokemonIndex(pokemon: pokemon)).png"
        : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(viewModel.getPokemonIndex(pokemon: pokemon)).png"
    }
}
