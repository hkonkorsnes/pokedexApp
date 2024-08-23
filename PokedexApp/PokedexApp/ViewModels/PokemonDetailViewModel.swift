import SwiftUI

final class PokemonDetailViewModel: ObservableObject {
    @Published var favoritedPokemon: [Pokemon] = []

    private var store: FavoritePokemonStore

    init(favoritedPokemonStore: FavoritePokemonStore) {
        self.store = favoritedPokemonStore
    }

    func onAppear() {
        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }

    func addFavorite(pokemon: Pokemon) {
        store.save(pokemon: pokemon)
        favoritedPokemon = store.favorites
    }

    func toggleFavoritePokemon(_ pokemon: Pokemon) {
        if isPokemonFavorited(pokemon) {
            store.delete(pokemon: pokemon)
        } else {
            store.save(pokemon: pokemon)
        }

        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }

    func isPokemonFavorited(_ pokemonToCheck: Pokemon) -> Bool {
        store.fetchPokemon()
        return store.favorites.contains { pokemon in
            pokemonToCheck.id == pokemon.id
        }
    }
}
