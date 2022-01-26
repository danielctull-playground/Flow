
import XCTest
import Flow

final class FlowTests: XCTestCase {

    struct Failure: Error {}
    struct SomeError: Error {}
    struct AnotherError: Error {}

    func testOutput() async throws {
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

    func testCatch() async throws {

        var failure: Error = Failure()
        let flow = Flow { throw failure }
            .catch { _ in 4 }

        do {
            failure = Failure()
            let output = try await flow()
            XCTAssertEqual(output, 4)
        }

        do {
            failure = AnotherError()
            let output = try await flow()
            XCTAssertEqual(output, 4)
        }
    }

    func testCatchSpecific() async throws {

        var failure: Error = Failure()
        let flow = Flow { throw failure }
            .catch(Failure.self) { _ in 1 }
            .catch { _ in 2 }

        do {
            failure = Failure()
            let output = try await flow()
            XCTAssertEqual(output, 1)
        }

        do {
            failure = SomeError()
            let output = try await flow()
            XCTAssertEqual(output, 2)
        }
    }

    func testFlatCatch() async throws {

        var failure: Error = Failure()
        let flow = Flow { throw failure }
            .flatCatch { _ in .just(4) }

        do {
            failure = Failure()
            let output = try await flow()
            XCTAssertEqual(output, 4)
        }

        do {
            failure = AnotherError()
            let output = try await flow()
            XCTAssertEqual(output, 4)
        }
    }

    func testFlatCatchSpecific() async throws {

        var failure: Error = Failure()
        let flow = Flow { throw failure }
            .flatCatch(Failure.self) { _ in .just(1) }
            .flatCatch { _ in .just(2) }

        do {
            failure = Failure()
            let output = try await flow()
            XCTAssertEqual(output, 1)
        }

        do {
            failure = SomeError()
            let output = try await flow()
            XCTAssertEqual(output, 2)
        }
    }

    func testMapError() async throws {

        var failure: Error = Failure()
        let flow = Flow { throw failure }
            .mapError { _ in SomeError() }

        failure = Failure()
        await AssertThrowsError(SomeError.self, try await flow())
        failure = AnotherError()
        await AssertThrowsError(SomeError.self, try await flow())
    }

    func testMapErrorSpecific() async throws {

        var failure: Error = Failure()
        let flow = Flow { throw failure }
            .mapError(Failure.self) { _ in SomeError() }

        failure = Failure()
        await AssertThrowsError(SomeError.self, try await flow())
        failure = AnotherError()
        await AssertThrowsError(AnotherError.self, try await flow())
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
