import XCTest
@testable import Foma

final class FomaTests: XCTestCase {
    func testFomaVersion() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Foma().version, "0.9.18alpha")
    }

    static var allTests = [
        ("testFomaVersion", testFomaVersion),
    ]
}
