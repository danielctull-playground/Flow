
import XCTest
import Flow

final class FlowTests: XCTestCase {

    struct Failure: Error {}
    struct SomeError: Error {}

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

    func testCatch() async throws {
        let flow = Flow<Void, Int> { throw Failure() }
            .catch { _ in 4 }
        let output = try await flow()
        XCTAssertEqual(output, 4)
    }

    func testCatchError() async throws {
        let flow = Flow<Error, Int> { throw $0 }
            .catch(Failure.self) { _ in 1 }
            .catch { _ in 2}

        do {
            let output = try await flow(Failure())
            XCTAssertEqual(output, 1)
        }

        do {
            let output = try await flow(SomeError())
            XCTAssertEqual(output, 2)
        }
    }

    func testRetry1() async throws {
        var attempts = 0
        let flow = Flow { attempts += 1; throw Failure() }
            .retry(1)
            .catch { _ in } // Allows test to pass
        try await flow()
        XCTAssertEqual(attempts, 1)
    }

    func testRetry2() async throws {
        var attempts = 0
        let flow = Flow { attempts += 1; throw Failure() }
            .retry(2)
            .catch { _ in } // Allows test to pass
        try await flow()
        XCTAssertEqual(attempts, 2)
    }

    func testRetry3() async throws {
        var attempts = 0
        let flow = Flow { attempts += 1; throw Failure() }
            .retry(3)
            .catch { _ in } // Allows test to pass
        try await flow()
        XCTAssertEqual(attempts, 3)
    }
}
