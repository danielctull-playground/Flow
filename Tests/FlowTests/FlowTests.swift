
import XCTest
import Flow

final class FlowTests: XCTestCase {

    func testInput() async throws {
        var input: Int?
        let flow = Flow { input = $0 }
        try await flow(2)
        XCTAssertEqual(input, 2)
    }

    func testOutput() async throws {
        let flow = Flow { "output" }
        let output = try await flow()
        XCTAssertEqual(output, "output")
    }

    func testInputOutput() async throws {
        let flow = Flow<Int, Int> { 2 * $0 }
        let output = try await flow(2)
        XCTAssertEqual(output, 4)
    }

    func testMap() async throws {
        let flow = Flow<Int, Int> { 2 * $0 }
            .map(String.init)
        let output = try await flow(2)
        XCTAssertEqual(output, "4")
    }
}
