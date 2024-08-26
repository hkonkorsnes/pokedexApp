//
//  RandomPokemonView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct RandomPokemonView: View {
    @ObservedObject var viewModel: RandomPokemonViewModel
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack {
            VStack() {
                if let randomPokemon = viewModel.randomPokemon, let url = viewModel.pokemonImageURL {
                    blackedOutPokemonImage(url)
                        .padding()
                    Spacer()

                    NavigationLink(
                        destination: PokemonDetailView(
                            viewModel: PokemonDetailViewModel(
                                pokemon: randomPokemon,
                                favoritedPokemonStore: FavoritePokemonStore(
                                    modelContext: modelContext
                                )
                            )
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
                    Button(action: viewModel.randomizePokemon) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            }
            .navigationTitle("Who's that Pokémon?")
            .onAppear {
                viewModel.loadRandomPokemon()
            }
        }
    }

    // MARK: - Blacked Out Pokemon Image
    private func blackedOutPokemonImage(_ url: String) -> some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.primary)
                    .shadow(radius: 10)
            case .failure:
                ProgressView()
            @unknown default:
                ProgressView()
            }
        }
    }
}

#Preview {
    RandomPokemonView(viewModel: RandomPokemonViewModel())
}
