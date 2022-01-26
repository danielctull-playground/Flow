
import XCTest
import Flow

final class CombinationTests: XCTestCase {

    func testMerge() async throws {
        let flow = Flow.just(4)
            .merge(with: .just("A"))
        let output = try await flow()
        XCTAssertEqual(output.0, 4)
        XCTAssertEqual(output.1, "A")
    }
}
