//
//  PokedexCellView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 25/08/2024.
//

import SwiftUI

struct PokedexCellView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    let pokemon: Pokemon
    var namespace: Namespace.ID
    @State private var backgroundColor: Color = .gray

    private let dimensions: Double = 160

    var body: some View {
        VStack {
            pokemonImageView
            pokemonNameView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(gradientBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(borderOverlay)
        .shadow(color: backgroundColor.opacity(0.6), radius: 10, x: 0, y: 5)
        .onAppear { updateBackgroundColor() }
    }

    private var pokemonImageView: some View {
        AsyncImage(url: URL(string: getPokemonImageURL())) { phase in
            switch phase {
            case .empty:
                ProgressView().frame(width: dimensions, height: dimensions)
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .frame(width: dimensions, height: dimensions)
                    .foregroundStyle(.gray)
                    .shadow(radius: 10)
                    .matchedGeometryEffect(id: "\(pokemon.id)-image", in: namespace)
            case .failure:
                ProgressView().frame(width: dimensions, height: dimensions)
            @unknown default:
                ProgressView().frame(width: dimensions, height: dimensions)
            }
        }
    }

    private var pokemonNameView: some View {
        Text(pokemon.name.capitalized)
            .font(.title2)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
            .padding()
            .matchedGeometryEffect(id: "\(pokemon.id)-text", in: namespace)
    }

    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                backgroundColor.opacity(0.8),
                backgroundColor.opacity(0.5)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.white.opacity(0.7), lineWidth: 2)
    }

    private func getPokemonImageURL() -> String {
        viewModel.isShiny
            ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(viewModel.getPokemonIndex(pokemon: pokemon)).png"
            : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(viewModel.getPokemonIndex(pokemon: pokemon)).png"
    }

    private func updateBackgroundColor() {
        viewModel.getDetails(pokemon: pokemon) { details in
            if let primaryType = details?.types.first?.type.name {
                backgroundColor = viewModel.color(forType: primaryType)
            } else {
                backgroundColor = .gray
            }
        }
    }
}
