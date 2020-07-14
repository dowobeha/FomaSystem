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
        let testFile = "/Users/lanes/work/summer/yupik/yupik-foma-v2/l2s.fomabin"
        if let fst = FST(fromBinary: testFile) {
            if let result = fst.applyUp("qikmiq") {
                XCTAssertEqual(result.input, "qikmiq")
                XCTAssertEqual(result.outputs, ["qikmigh(N)^[Abs.Sg]"])
            } else {
                XCTFail("applyUp failed")
            }
        } else {
            XCTFail("Failed to read binary file \(testFile)")
        }
    }

    static var allTests = [
        ("testFomaVersion", testFomaVersion),
    ]
}
