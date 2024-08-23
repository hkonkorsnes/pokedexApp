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
    @Environment(\.modelContext) var modelContext
    @AppStorage("randomPokemonID") private var randomPokemonID: String?
    @State private var randomPokemon: Pokemon?
    @State private var pokemonImageURL: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let randomPokemon, let url = pokemonImageURL {
                    NavigationLink(
                        destination: PokemonDetailView(
                            viewModel: PokemonDetailViewModel(
                                favoritedPokemonStore: FavoritePokemonStore(
                                    modelContext: modelContext
                                )
                            ), pokemon: randomPokemon
                        )
                    ) {
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
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Who's that Pokémon?")
            .onAppear {
                loadRandomPokemon()
            }
        }
    }

    // MARK: - Pokemon Card View
    private func pokemonCardView(with imageURL: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(radius: 5)

            HStack(alignment: .center) {
                blackedOutPokemonImage(imageURL)

                VStack {
                    Spacer()
                    Text("Tap to reveal \(Image(systemName: "chevron.right"))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                .frame(maxHeight: .infinity)
                .padding(.bottom, 8)

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
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(colorScheme == .dark ? .white : .black) // Black/white out the image
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
        return viewModel.isShiny
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
        guard let randomPokemonID else {
            randomizePokemon()
            return
        }

        guard let pokemon = viewModel.pokemonList.first(where: { $0.id == randomPokemonID }) else {
            randomizePokemon()
            return
        }

        self.randomPokemon = pokemon
        self.pokemonImageURL = getPokemonImageURL(id: pokemon.id)
    }
}

#Preview {
    RandomPokemonView()
        .environmentObject(PokemonViewModel())
}
