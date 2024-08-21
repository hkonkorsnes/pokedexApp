//
//  ContentView.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PokemonViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    let adaptiveColumns = [
                        GridItem(.adaptive(minimum: 150))
                    ]
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        ForEach(viewModel.filteredPokemon) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                PokeDexView(pokemon: pokemon)
                            }
                        }
                    }
                    .animation(.easeIn(duration: 0.3), value: viewModel.filteredPokemon.count)
                    .navigationTitle("Pokédex")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu(content: {
                                Button(role: .none) {
                                    viewModel.isShiny.toggle()
                                    print("Shiny shown: \(viewModel.isShiny)")
                                } label: {
                                    Label("Toggle shiny variants", systemImage: "sparkles")
                                }
                            }, label: {
                                Image(systemName: "ellipsis.circle")
                                    .imageScale(.large)
                            })
                        }
                    }
                }
                .searchable(text: $viewModel.searchText)
            }
            .tabItem {
                Label("Pokédex", systemImage: "list.dash")
            }

            NavigationStack {
                SavedPokemonView()
                    .navigationTitle("Saved Pokémon")
            }
            .tabItem {
                Label("Saved", systemImage: "heart.fill")
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
