//
//  RandomPokemonView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct RandomPokemonView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    @Environment(\.modelContext) var modelContext
    @AppStorage("randomPokemonID") private var randomPokemonID: String?
    @State private var randomPokemon: Pokemon?
    @State private var pokemonImageURL: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let randomPokemon, let url = pokemonImageURL {
                    blackedOutPokemonImage(url)
                        .padding()
                    Spacer()

                    NavigationLink(
                        destination: PokemonDetailView(
                            viewModel: PokemonDetailViewModel(
                                favoritedPokemonStore: FavoritePokemonStore(
                                    modelContext: modelContext
                                )
                            ), pokemon: randomPokemon
                        )
                    ) {
                        Text("Reveal Pokémon \(Image(systemName: "chevron.right"))")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                } else {
                    Text("Press the button to show a random Pokémon")
                        .font(.headline)
                        .padding()
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: randomizePokemon) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            }
            .navigationTitle("Who's that Pokémon?")
            .onAppear {
                loadRandomPokemon()
            }
        }
    }

    // MARK: - Blacked Out Pokemon Image
    private func blackedOutPokemonImage(_ url: String) -> some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 120, height: 120)
            case .success(let image):
                image
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.primary)
                    .shadow(radius: 10)
            case .failure:
                ProgressView()
                    .frame(width: 120, height: 120)
            @unknown default:
                ProgressView()
                    .frame(width: 120, height: 120)
            }
        }
    }

    // MARK: - Functions
    private func getPokemonImageURL(id: String) -> String {
        viewModel.isShiny
        ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(id).png"
        : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }

    private func randomizePokemon() {
        if let pokemon = viewModel.pokemonList.randomElement() {
            viewModel.getDetails(pokemon: pokemon) { _ in
                self.randomPokemon = pokemon
                self.randomPokemonID = pokemon.id  // Save the ID
                self.pokemonImageURL = getPokemonImageURL(id: pokemon.id)
            }
        }
    }

    private func loadRandomPokemon() {
        if let randomPokemonID = randomPokemonID,
           let pokemon = viewModel.pokemonList.first(where: { $0.id == randomPokemonID }) {
            self.randomPokemon = pokemon
            self.pokemonImageURL = getPokemonImageURL(id: pokemon.id)
        } else {
            randomizePokemon()
        }
    }
}

#Preview {
    RandomPokemonView()
        .environmentObject(PokemonViewModel())
}
