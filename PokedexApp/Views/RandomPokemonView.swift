//
//  RandomPokemonView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct RandomPokemonView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("randomPokemonID") private var randomPokemonID: String?
    @State private var randomPokemon: Pokemon?

    var body: some View {
        NavigationStack {
            VStack {
                if let pokemon = randomPokemon {
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                        PokeDexView(pokemon: pokemon)
                            .padding()
                            .blur(radius: 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                            )

                    }
                } else {
                    Text("Press the button to show a random Pokémon")
                        .padding()
                }
                Spacer()
                Button(action: randomizePokemon) {
                    Text("\(Image(systemName: "shuffle")) Randomize Pokémon")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .onAppear(perform: loadRandomPokemon)
            .navigationTitle("Who's that Pokémon?")
        }
        Spacer()
    }

    private func randomizePokemon() {
        if let pokemon = viewModel.pokemonList.randomElement() {
            self.randomPokemon = pokemon
            self.randomPokemonID = pokemon.id.uuidString
        }
    }

    private func loadRandomPokemon() {
        if let savedID = randomPokemonID,
           let uuid = UUID(uuidString: savedID),
           let pokemon = viewModel.pokemonList.first(where: { $0.id == uuid }) {
            self.randomPokemon = pokemon
        } else {
            randomizePokemon()
        }
    }
}
