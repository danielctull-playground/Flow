
import XCTest
import Flow

final class FlowErrorHandlingTests: XCTestCase {

    struct Failure: Error {}
    struct SomeError: Error {}
    struct AnotherError: Error {}

    func testCatch() async throws {

        var failure: Error = Failure()
        let flow = Flow { throw failure }
            .catch { _ in .just(4) }

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
            .catch(Failure.self) { _ in .just(1) }
            .catch { _ in .just(2) }

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
        await AssertFlowThrowsError(flow, SomeError.self)
        failure = AnotherError()
        await AssertFlowThrowsError(flow, SomeError.self)
    }

    func testMapErrorSpecific() async throws {

        var failure: Error = Failure()
        let flow = Flow { throw failure }
            .mapError(Failure.self) { _ in SomeError() }

        failure = Failure()
        await AssertFlowThrowsError(flow, SomeError.self)
        failure = AnotherError()
        await AssertFlowThrowsError(flow, AnotherError.self)
    }

    func testRetry1() async throws {
        var attempts = 0
        let flow = Flow { attempts += 1; throw Failure() }
            .retry(1)
            .catch { _ in .just(()) } // Allows test to pass
        try await flow()
        XCTAssertEqual(attempts, 1)
    }

    func testRetry2() async throws {
        var attempts = 0
        let flow = Flow { attempts += 1; throw Failure() }
            .retry(2)
            .catch { _ in .just(()) } // Allows test to pass
        try await flow()
        XCTAssertEqual(attempts, 2)
    }

    func testRetry3() async throws {
        var attempts = 0
        let flow = Flow { attempts += 1; throw Failure() }
            .retry(3)
            .catch { _ in .just(()) } // Allows test to pass
        try await flow()
        XCTAssertEqual(attempts, 3)
    }
}

final class TaskErrorHandlingTests: XCTestCase {

    func testCatch() async throws {
        struct Failure: Error {}
        let task = Task.fail(Failure())
            .catch { _ in .just(4) }
        await AssertSuccess(task, 4)
    }

    func testCatchSpecific() async throws {
        struct FailureA: Error {}
        struct FailureB: Error {}

        do {
            let task = Task.fail(FailureA())
                .catch(FailureA.self) { _ in .just("A") }
                .catch { _ in .just("B") }
            await AssertSuccess(task, "A")
        }
        do {
            let task = Task.fail(FailureB())
                .catch(FailureA.self) { _ in .just("A") }
                .catch { _ in .just("B") }
            await AssertSuccess(task, "B")
        }
    }

    func testMapError() async throws {
        struct FailureA: Error {}
        struct FailureB: Error {}
        let task = Task<String, Error>
            .fail(FailureA())
            .mapError { _ in FailureB() }
        await AssertFailure(task, FailureB.self)
    }

    func testMapErrorSpecific() async throws {
        struct FailureA: Error {}
        struct FailureB: Error {}
        struct FailureC: Error {}

        do {
            let task = Task<String, Error>
                .fail(FailureA())
                .mapError(FailureA.self) { _ in FailureC() }
            await AssertFailure(task, FailureC.self)
        }
        do {
            let task = Task<String, Error>
                .fail(FailureB())
                .mapError(FailureA.self) { _ in FailureC() }
            await AssertFailure(task, FailureB.self)
        }
    }
}
