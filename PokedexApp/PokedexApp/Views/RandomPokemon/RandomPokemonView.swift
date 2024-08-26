//
//  RandomPokemonView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct RandomPokemonView: View {
    @StateObject var viewModel: RandomPokemonViewModel
    @Environment(\.modelContext) var modelContext

    init() {
        self._viewModel = StateObject(wrappedValue: RandomPokemonViewModel())
    }

    var body: some View {
        VStack() {
            if let randomPokemon = viewModel.randomPokemon, let url = viewModel.pokemonImageURL {
                blackedOutPokemonImage(url)
                    .padding()
                Spacer()

                NavigationLink(
                    destination: PokemonDetailView(
                        pokemon: randomPokemon,
                        store: FavoritePokemonStore(
                            modelContext: modelContext
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
            viewModel.loadInitialRandomPokemon()
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
    RandomPokemonView()
}
