//
//  CharacterModel.swift
//  TechnicalTest
//
//  Created by Avadh Bambhroliya on 31/03/25.
//

// MARK: - Model
struct CharacterResponse: Codable {
    let info: PageInfo?
    let results: [Character]?
}

struct PageInfo: Codable {
    var count: Int?
    var pages: Int?
    var next: String?
    var prev: String?
    
    init(count: Int?, pages: Int?, next: String?, prev: String?) {
        self.count = count
        self.pages = pages
        self.next = next
        self.prev = prev
    }
}

struct Character: Codable, Identifiable, Equatable {
    let id: Int
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin: LocationInfo?
    var location: LocationInfo?
    var image: String?
    var episode: [String]?
    var url: String?
    var created: String?
    
    init(id: Int, name: String?, status: String?, species: String?, type: String?, gender: String?, origin: LocationInfo?, location: LocationInfo?, image: String?, episode: [String]?, url: String?, created: String?) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return false
    }
    
    static var standardValue: Character {
        return Character(id: 1, name: "Rick Sanchez", status: "", species: "", type: "", gender: "", origin: LocationInfo(name: "", url: ""), location: LocationInfo(name: "", url: ""), image: "", episode: [""], url: "", created: "")
    }
}

struct LocationInfo: Codable {
    let name: String?
    let url: String?
}


