import XCTest
@testable import SpiceShelf

@MainActor
final class SpiceShelfTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
    }

    func testSeedDataStaysUnderFreeLimit() {
        XCTAssertLessThan(Store.seedData.count, Store.freeLimit)
    }

    func testAddItem() {
        store.add(name: "Test Spice", purchaseDate: "2026-01-15", shelfLife: "12 months")
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.name, "Test Spice")
    }

    func testCanAddBelowLimit() {
        XCTAssertTrue(store.canAdd())
    }

    func testFreeLimitBlocksAdd() {
        for i in 0..<Store.freeLimit {
            store.add(name: "Item \(i)", purchaseDate: "2026-01-15", shelfLife: "12 months")
        }
        XCTAssertFalse(store.canAdd())
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(name: "Item \(i)", purchaseDate: "2026-01-15", shelfLife: "12 months")
        }
        XCTAssertTrue(store.canAdd())
    }

    func testDeleteItem() {
        store.add(name: "ToDelete", purchaseDate: "2026-01-15", shelfLife: "12 months")
        let item = store.items[0]
        store.delete(item)
        XCTAssertEqual(store.items.count, 0)
    }

    func testUpdateItem() {
        store.add(name: "Original", purchaseDate: "2026-01-15", shelfLife: "12 months")
        var item = store.items[0]
        item.name = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.name, "Updated")
    }

    func testDeleteAtOffsets() {
        store.add(name: "A", purchaseDate: "2026-01-15", shelfLife: "12 months")
        store.add(name: "B", purchaseDate: "2026-01-15", shelfLife: "12 months")
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.name, "B")
    }
}
