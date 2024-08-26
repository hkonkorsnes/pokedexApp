//
//  PokedexCellView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 25/08/2024.
//

import SwiftUI

struct PokedexCellView: View {
    let pokemon: Pokemon
    @ObservedObject var viewModel: PokedexViewModel
    @State private var backgroundColor: Color = .gray

    private let dimensions: Double = 160

    var body: some View {
        VStack {
            pokemonImageView
            pokemonNameView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))    }

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
            .foregroundStyle(.primary)
            .padding()
    }
}
