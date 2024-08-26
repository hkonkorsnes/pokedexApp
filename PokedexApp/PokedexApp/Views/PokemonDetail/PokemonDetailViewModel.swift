import SwiftUI

final class PokemonDetailViewModel: ObservableObject {
    let pokemon: Pokemon
    private let pokemonManager = PokemonManager()

    @Published var pokemonDetails: DetailedPokemon? = nil
    @Published var pokemonSpecies: PokemonSpecies? = nil
    @Published var showError: Bool = false
    @Published var favoritedPokemon: [Pokemon] = []
    @Published var backgroundColor: Color = .gray

    @AppStorage("isShiny") var isShiny = false

    private var store: FavoritePokemonStore

    init(pokemon: Pokemon, favoritedPokemonStore: FavoritePokemonStore) {
        self.pokemon = pokemon
        self.store = favoritedPokemonStore
        fetchPokemonDetails()
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

    // Connects Pokémon type to a color
    func color(forType type: String) -> Color {
        switch type.lowercased() {
        case "normal":
            return Color.gray
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "grass":
            return Color.green
        case "ice":
            return Color.teal
        case "electric":
            return Color.yellow
        case "psychic":
            return Color.pink
        case "dragon":
            return Color.indigo
        case "poison":
            return Color.purple
        case "fighting":
            return Color.brown
        case "rock":
            return Color.brown
        case "flying":
            return Color.mint
        case "bug":
            return Color.green
        case "ghost":
            return Color.purple
        default:
            return Color.gray
        }
    }

    func updateBackgroundColor() {
        guard let pokemonDetails else { return }
        if let primaryType = pokemonDetails.types.first?.type.name {
            backgroundColor = color(forType: primaryType)
        } else {
            backgroundColor = .gray
        }
    }
}
