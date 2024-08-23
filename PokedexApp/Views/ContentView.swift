//
//  ContentView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @StateObject var viewModel = PokemonViewModel()

    private var columns: [GridItem] {
        if dynamicTypeSize.isAccessibilitySize {
            return [
                GridItem(.flexible())
            ]
        }

        return [
            GridItem(.adaptive(minimum: 150))
        ]
    }

    @Namespace private var detailAnimationNamespace

    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredPokemon) { pokemon in
                            NavigationLink(
                                destination: PokemonDetailView(
                                    viewModel: PokemonDetailViewModel(
                                        favoritedPokemonStore: FavoritePokemonStore(
                                            modelContext: modelContext
                                        )
                                    ), pokemon: pokemon
                                )
                                .navigationTransition(.zoom(sourceID: "pokemon", in: detailAnimationNamespace))
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
