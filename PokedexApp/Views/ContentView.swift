//
//  ContentView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel = PokemonViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    let adaptiveColumns = [
                        GridItem(.adaptive(minimum: 150))
                    ]
                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                        ForEach(viewModel.filteredPokemon) { pokemon in
                            NavigationLink(
                                destination: PokemonDetailView(
                                    viewModel: PokemonDetailViewModel(
                                        favoritedPokemonStore: FavoritePokemonStore(
                                            modelContext: modelContext
                                        )
                                    ), pokemon: pokemon
                                )
                            ) {
                                PokeDexView(pokemon: pokemon)
                            }
                        }
                    }
                    .padding()
                    .navigationTitle("Pokédex")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button(action: {
                                    viewModel.isShiny.toggle()
                                }) {
                                    Label("Toggle shiny variants", systemImage: "sparkles")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .imageScale(.large)
                            }
                        }
                    }
                }
                .searchable(text: $viewModel.searchText)
            }
            .tabItem {
                Label("Pokédex", systemImage: "list.dash")
            }

            NavigationStack {
                FavoritedPokemonView(
                    viewModel: FavoritedPokemonViewModel(
                        favoritedPokemonStore: FavoritePokemonStore(modelContext: modelContext)
                    )
                ) 
                .navigationTitle("Saved Pokémon")
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }

            NavigationStack {
                RandomPokemonView()
                    .navigationTitle("Who's that Pokémon?")
            }
            .tabItem {
                Label("Who", systemImage: "person.fill.questionmark")
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
