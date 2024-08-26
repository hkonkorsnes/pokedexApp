//
//  PokedexCellView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 25/08/2024.
//

import SwiftUI

struct PokedexCellView: View {
    let pokemon: Pokemon
    let viewModel: PokedexViewModel
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
//        .onAppear { updateBackgroundColor() }
    }

    private var pokemonImageView: some View {
        AsyncImage(url: URL(string: viewModel.fetchPokemonImageURL(for: pokemon))) { phase in
            switch phase {
            case .empty:
                ProgressView().frame(width: dimensions, height: dimensions)
            case .success(let image):
                image.resizable()
                    .scaledToFit()
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

//    private func updateBackgroundColor() {
//        viewModel.fetchDetails(pokemon: pokemon) { details in
//            if let primaryType = details?.types.first?.type.name {
//                backgroundColor = viewModel.color(forType: primaryType)
//            } else {
//                backgroundColor = .gray
//            }
//        }
//    }
}
