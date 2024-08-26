//
//  FavoritedPokemonView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI
import SwiftData

struct FavoritedPokemonView: View {
    @StateObject var viewModel: FavoritedPokemonViewModel

    @Environment(\.modelContext) var modelContext

    init(store: FavoritePokemonStore) {
        self._viewModel = StateObject(wrappedValue: FavoritedPokemonViewModel(favoritedPokemonStore: store))
    }

    var body: some View {
        VStack {
            if viewModel.favoritedPokemon.isEmpty {
                noFavoritePokemonSection
            } else {
                List(viewModel.favoritedPokemon) { pokemon in
                    NavigationLink(
                        destination: PokemonDetailView(
                            pokemon: pokemon,
                            store: FavoritePokemonStore(
                                modelContext: modelContext
                            )
                        )
                    ) {
                        HStack {
                            AsyncImage(
                                url: URL(
                                    string: viewModel.fetchPokemonImageURL(id: pokemon.id)
                                )
                            ) { image in
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
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Favorite Pokémon")
        .onAppear {
            viewModel.onAppear()
        }
    }

    private var noFavoritePokemonSection: some View {
        Section {
            ContentUnavailableView {
                Label("No Pokémon favorited yet", systemImage: "heart.slash")
            } description: {
                Text("It doesn't seem like you have favorited any Pokémon yet. Pokémon will be saved here when you favorite them")
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pokemon.self, configurations: config)
    let pokemon = Pokemon.samplePokemon

    FavoritedPokemonView(store: FavoritePokemonStore(modelContext: ModelContext(container)))
}
