//
//  FavoritedPokemonView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI
import SwiftData

struct FavoritedPokemonView: View {
    @ObservedObject var viewModel: FavoritedPokemonViewModel
    @EnvironmentObject var pokemonViewModel: PokemonViewModel

    @Environment(\.modelContext) var modelContext

    init(viewModel: FavoritedPokemonViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if viewModel.favoritedPokemon.isEmpty {
                noFavoritePokemonSection
            } else {
                List(viewModel.favoritedPokemon) { pokemon in
                    NavigationLink(
                        destination: PokemonDetailView(
                            viewModel: PokemonDetailViewModel(
                                favoritedPokemonStore: FavoritePokemonStore(
                                    modelContext: modelContext
                                )
                            ), pokemon: pokemon
                        )
                    ) {
                        HStack {
                            AsyncImage(
                                url: URL(
                                    string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonViewModel.getPokemonIndex(pokemon: pokemon)).png"
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
                .listStyle(PlainListStyle())
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
                Text("It doesn't seem like you have favorited any Pokémon yet. Pokémon will be saved here when you havorite them")
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pokemon.self, configurations: config)
    let pokemon = Pokemon.samplePokemon

    FavoritedPokemonView(
        viewModel: FavoritedPokemonViewModel(
            favoritedPokemonStore: FavoritePokemonStore(
                modelContext: ModelContext(container)
            )
        )
    )
        .environmentObject(PokemonViewModel())
}
