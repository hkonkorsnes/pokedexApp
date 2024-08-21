//
//  FavoritedPokemonView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI
import SwiftData

struct FavoritedPokemonView: View {
    @EnvironmentObject var viewModel: PokemonViewModel

    var body: some View {
        VStack {
            if viewModel.favoritedPokemon.isEmpty {
                Text("No Pokémon favorited yet. 😢")
                    .font(.headline)
                    .padding()
            } else {
                List(viewModel.favoritedPokemon) { pokemon in
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                        HStack {
                            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(viewModel.getPokemonIndex(pokemon: pokemon)).png")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }
                            Text(pokemon.name.capitalized)
                                .font(.headline)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Favorite Pokémon")
        .onAppear {
            viewModel.loadFavoritedPokemon() // Custom method to load favorited Pokémon
        }
    }
}

#Preview {
    FavoritedPokemonView()
        .environmentObject(PokemonViewModel())
}
