
import XCTest
import Flow

final class ErrorHandlingTests: XCTestCase {

    struct Failure: Error {}
    struct ErrorA: Error {}
    struct ErrorB: Error {}
    struct ErrorC: Error {}

    func testCatch() async throws {

        await AssertOutput(4) {
            Flow.fail(ErrorA())
                .catch { _ in .just(4) }
        }
    }

    func testCatchSpecific() async throws {

        await AssertOutput(1) {
            Flow.fail(ErrorA())
                .catch(ErrorA.self) { _ in .just(1) }
                .catch { _ in .just(2) }
        }

        await AssertOutput(2) {
            Flow.fail(ErrorB())
                .catch(ErrorA.self) { _ in .just(1) }
                .catch { _ in .just(2) }
        }
    }

    func testMapError() async throws {

        await AssertThrows(ErrorB.self) {
            Flow<Int>
                .fail(ErrorA())
                .mapError { _ in ErrorB() }
        }
    }

    func testMapErrorSpecific() async throws {

        await AssertThrows(ErrorA.self) {
            Flow<Int>
                .fail(ErrorA())
                .mapError(ErrorB.self) { _ in ErrorC() }
        }

        await AssertThrows(ErrorC.self) {
            Flow<Int>
                .fail(ErrorB())
                .mapError(ErrorB.self) { _ in ErrorC() }
        }
    }

    func testRetry1() async throws {

        let attempts = AsyncBox(0)

        await AssertThrows(Failure.self) {
            Flow {
                await attempts.increment()
                throw Failure()
            }
            .retry(1)
        }

        let a = await attempts.value
        XCTAssertEqual(a, 1)
    }

    func testRetry2() async throws {

        let attempts = AsyncBox(0)

        await AssertThrows(Failure.self) {
            Flow {
                await attempts.increment()
                throw Failure()
            }
            .retry(2)
        }

        let a = await attempts.value
        XCTAssertEqual(a, 2)
    }

    func testRetry3() async throws {

        let attempts = AsyncBox(0)

        await AssertThrows(Failure.self) {
            Flow {
                await attempts.increment()
                throw Failure()
            }
            .retry(3)
        }

        let a = await attempts.value
        XCTAssertEqual(a, 3)
    }
}
