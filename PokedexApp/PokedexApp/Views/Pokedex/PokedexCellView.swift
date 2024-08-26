//
//  PokedexCellView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 25/08/2024.
//

import SwiftUI

struct PokedexCellView: View {
    @StateObject var viewModel: PokemonCellViewModel
    private let dimensions: Double = 160

    init(pokemon: Pokemon) {
        self._viewModel = StateObject(wrappedValue: PokemonCellViewModel(pokemon: pokemon))
    }

    var body: some View {
        VStack {
            pokemonImageView
            pokemonNameView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(gradientBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                viewModel.backgroundColor.opacity(0.8),
                viewModel.backgroundColor.opacity(0.5)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    }

    private var pokemonImageView: some View {
        AsyncImage(url: URL(string: viewModel.fetchPokemonImageURL(for: viewModel.pokemon))) { phase in
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
        Text(viewModel.pokemon.name.capitalized)
            .font(.title2)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
            .padding()
    }
}
