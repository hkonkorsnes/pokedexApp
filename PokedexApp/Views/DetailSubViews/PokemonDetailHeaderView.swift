//
//  PokemonDetailHeaderView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 22/08/2024.
//

import SwiftUI

struct PokemonDetailHeaderView: View {
    let pokemon: Pokemon
    let backgroundColor: Color
    let imageUrl: String
    
    var body: some View {
        ZStack {
            backgroundRectangle
            VStack {
                pokemonImage
                    .frame(width: 270, height: 270)
                Text(pokemon.name.capitalized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .padding(.bottom)
        }
        .padding(.horizontal)
    }
    
    private var backgroundRectangle: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        backgroundColor.opacity(0.6),
                        backgroundColor.opacity(0.2)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(maxWidth: .infinity)
    }
    
    private var pokemonImage: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 270, height: 270)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 270, height: 270)
                    .shadow(radius: 10)
            case .failure:
                Image(systemName: "xmark.octagon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270, height: 270)
                    .foregroundStyle(.red)
            @unknown default:
                Image(systemName: "questionmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270, height: 270)
                    .foregroundStyle(.gray)
            }
        }
    }
}


#Preview {
    PokemonDetailHeaderView(pokemon: Pokemon.samplePokemon, backgroundColor: .red, imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/151/.png")
}
