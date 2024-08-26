import SwiftUI

final class PokemonDetailViewModel: ObservableObject {

    let pokemon: Pokemon
    private var store: FavoritePokemonStore
    private let pokemonManager = PokemonManager()

    @Published var pokemonDetails: DetailedPokemon? = nil
    @Published var pokemonSpecies: PokemonSpecies? = nil
    @Published var showError: Bool = false
    @Published var favoritedPokemon: [Pokemon] = []
    @Published var backgroundColor: Color = .gray

    @AppStorage("isShiny") var isShiny = false

    init(pokemon: Pokemon, favoritedPokemonStore: FavoritePokemonStore) {
        self.pokemon = pokemon
        self.store = favoritedPokemonStore
        fetchPokemonDetails()
    }

    func onAppear() {
        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }

    func addFavorite() {
        store.save(pokemon: pokemon)
        favoritedPokemon = store.favorites
    }

    func toggleFavoritePokemon() {
        if isPokemonFavorited() {
            store.delete(pokemon: pokemon)
        } else {
            store.save(pokemon: pokemon)
        }

        store.fetchPokemon()
        favoritedPokemon = store.favorites
    }

    func isPokemonFavorited() -> Bool {
        store.fetchPokemon()
        return store.favorites.contains { pokemon in
            self.pokemon.id == pokemon.id
        }
    }

    func formatHeightWeight(value: Int) -> String {
        let dValue = Double(value)
        return String(format: "%.2f", dValue / 10)
    }

    func fetchPokemonImageURL() -> String {
        let index = pokemonDetails?.id ?? 0
        let baseUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        return isShiny ? "\(baseUrl)shiny/\(index).png" : "\(baseUrl)\(index).png"
    }

    func fetchPokemonDetails() {
        Task {
            let details = await fetchDetails()
            let species = await fetchPokemonSpecies(url: details?.species.url)
            DispatchQueue.main.async {
                self.pokemonDetails = details
                self.pokemonSpecies = species
                self.updateBackgroundColor()
            }
        }
    }

    func fetchDetails() async -> DetailedPokemon? {
        guard pokemonDetails == nil else { return nil }

        return await pokemonManager.fetchDetailedPokemon(url: pokemon.url)
    }

    func fetchPokemonSpecies(url: URL?) async -> PokemonSpecies? {
        guard let url else { return nil }
        guard pokemonSpecies == nil else { return nil }

        return await pokemonManager.fetchSpecies(url: url)
    }

    func updateBackgroundColor() {
        guard let pokemonDetails else { return }
        if let primaryType = pokemonDetails.types.first?.type {
            backgroundColor = primaryType.color()
        } else {
            backgroundColor = .gray
        }
    }
}
