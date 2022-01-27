
import XCTest
import Flow

final class CreationTests: XCTestCase {

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
        struct Failure: Error {}
        let flow = Flow<Void>.fail(Failure())
        await AssertFlowThrowsError(flow, Failure.self)
    }
}
