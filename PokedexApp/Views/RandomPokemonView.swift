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
    @State private var pokemonImageURL: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let pokemon = randomPokemon, let url = pokemonImageURL {
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                        pokemonCardView(with: url)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                } else {
                    Text("Press the button to show a random Pokémon")
                        .font(.headline)
                        .padding()
                }

                Spacer()

                Button(action: randomizePokemon) {
                    HStack {
                        Image(systemName: "shuffle")
                        Text("Randomize Pokémon")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Who's that Pokémon?")
            .onAppear(perform: loadRandomPokemon)
        }
    }

    // MARK: - Pokemon Card View
    private func pokemonCardView(with imageURL: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(radius: 5)

            VStack {
                blackedOutPokemonImage(imageURL)
                    .frame(width: 120, height: 120)

                HStack {
                    Spacer()
                    Text("Tap to reveal \(Image(systemName: "chevron.right"))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            .padding()
        }
        .frame(height: 200)
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
                    .resizable()
                    .scaledToFit()
                    .colorMultiply(.black) // Black out the image
                    .shadow(radius: 10)
            case .failure:
                Image(systemName: "xmark.octagon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.red)
            @unknown default:
                Image(systemName: "questionmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }
        }
    }

    // MARK: - Functions
    private func getPokemonImageURL(for pokemon: Pokemon) -> String {
        return viewModel.isShiny
            ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(viewModel.getPokemonIndex(pokemon: pokemon)).png"
            : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(viewModel.getPokemonIndex(pokemon: pokemon)).png"
    }

    private func randomizePokemon() {
        if let pokemon = viewModel.pokemonList.randomElement() {
            self.randomPokemon = pokemon
            self.randomPokemonID = pokemon.id  // Save the ID
            self.pokemonImageURL = getPokemonImageURL(for: pokemon)
        }
    }

    private func loadRandomPokemon() {
        if let savedID = randomPokemonID,
           let pokemon = viewModel.pokemonList.first(where: { $0.id == savedID }) {
            self.randomPokemon = pokemon
            self.pokemonImageURL = getPokemonImageURL(for: pokemon)
        } else {
            randomizePokemon()
        }
    }
}

#Preview {
    RandomPokemonView()
        .environmentObject(PokemonViewModel())
}
