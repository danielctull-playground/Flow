
import XCTest
import Flow

final class FlowCreationTests: XCTestCase {

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

final class TaskCreationTests: XCTestCase {

    func testJust() async {
        await AssertSuccess(Task<String, Never>.just("Hello"), "Hello")
        await AssertSuccess(Task<String, Error>.just("Goodbye"), "Goodbye")
    }

    func testFail() async throws {
        struct Failure: Error {}
        await AssertFailure(Task<String, Error>.fail(Failure()), Failure.self)
    }
}
