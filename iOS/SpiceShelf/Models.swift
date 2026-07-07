import Foundation

struct SpiceItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var purchaseDate: String
    var shelfLife: String
    var notes: String = ""
    var dateAdded: Date = Date()
}
