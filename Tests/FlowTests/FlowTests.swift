
import XCTest
import Flow

final class FlowTests: XCTestCase {

    struct Failure: Error {}

    func testInit() async throws {
        let flow = Flow { "output" }
        let output = try await flow()
        XCTAssertEqual(output, "output")
    }

    func testJust() async throws {
        let flow = Flow.just("output")
        let output = try await flow()
        XCTAssertEqual(output, "output")
    }

    func testFail() async throws {
        let flow = Flow<Void>.fail(Failure())
        await AssertThrowsError(Failure.self, try await flow())
    }
}
