
import XCTest
import Flow

final class FlowTests: XCTestCase {

    struct Failure: Error {}
    struct SomeError: Error {}
    struct AnotherError: Error {}

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

        let flow = Flow<Error, Int> { throw $0 }
            .catch { _ in 4 }

        do {
            let output = try await flow(Failure())
            XCTAssertEqual(output, 4)
        }

        do {
            let output = try await flow(AnotherError())
            XCTAssertEqual(output, 4)
        }
    }

    func testCatch_ignoreArgument() async throws {

        let flow = Flow<Error, Int> { throw $0 }
            .catch { 4 }

        do {
            let output = try await flow(Failure())
            XCTAssertEqual(output, 4)
        }

        do {
            let output = try await flow(AnotherError())
            XCTAssertEqual(output, 4)
        }
    }

    func testCatchSpecific() async throws {

        let flow = Flow<Error, Int> { throw $0 }
            .catch(Failure.self) { _ in 1 }
            .catch { _ in 2 }

        do {
            let output = try await flow(Failure())
            XCTAssertEqual(output, 1)
        }

        do {
            let output = try await flow(SomeError())
            XCTAssertEqual(output, 2)
        }
    }

    func testCatchSpecific_ignoreArgument() async throws {

        let flow = Flow<Error, Int> { throw $0 }
            .catch(Failure.self) { 1 }
            .catch { 2 }

        do {
            let output = try await flow(Failure())
            XCTAssertEqual(output, 1)
        }

        do {
            let output = try await flow(SomeError())
            XCTAssertEqual(output, 2)
        }
    }

    func testMapError() async throws {

        let flow = Flow<Error, Void> { throw $0 }
            .mapError { _ in SomeError() }

        await AssertThrowsError(SomeError.self, try await flow(Failure()))
        await AssertThrowsError(SomeError.self, try await flow(AnotherError()))
    }

    func testMapErrorSpecific() async throws {

        let flow = Flow<Error, Void> { throw $0 }
            .mapError(Failure.self) { _ in SomeError() }

        await AssertThrowsError(SomeError.self, try await flow(Failure()))
        await AssertThrowsError(AnotherError.self, try await flow(AnotherError()))
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

// MARK - Asserts

func AssertThrowsError<E: Error, T>(
    _ error: E.Type,
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (E) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
    } catch let error as E {
        errorHandler(error)
    } catch {
        XCTFail("Expected error of type \(E.self) but found \(error) instead.")
    }
}

