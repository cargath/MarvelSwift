import XCTest
@testable import MarvelKit

final class MarvelKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MarvelKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
