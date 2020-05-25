import XCTest
@testable import Foma

final class FomaTests: XCTestCase {
    func testFomaVersion() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Foma.version, "0.9.18alpha")
    }

    func testFomaReadBinaryFile() {
        let fsm = FSM(fromBinary: "/Users/lanes/work/summer/yupik/yupik-foma-v2/lower.fomabin")
        XCTAssertEqual(fsm.applyUp("qikmiq"), "qikmigh(N)^[Abs.Sg]")
    }

    static var allTests = [
        ("testFomaVersion", testFomaVersion),
    ]
}
