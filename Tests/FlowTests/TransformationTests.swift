
import XCTest
import Flow

final class TransformationTests: XCTestCase {

    func testMap() async throws {
        let flow = Flow.just(4)
            .map(String.init)
        let output = try await flow()
        XCTAssertEqual(output, "4")
    }

    func testFlatMap() async throws {
        let flow = Flow.just(4)
            .flatMap { value in
                Flow { String(value) }
            }
        let output = try await flow()
        XCTAssertEqual(output, "4")
    }
}
