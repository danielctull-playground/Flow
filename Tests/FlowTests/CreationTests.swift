
import XCTest
import Flow

final class CreationTests: XCTestCase {

    func testInit() async throws {
        await AssertOutput("output") {
            Flow { "output" }
        }
    }

    func testJust() async throws {
        await AssertOutput("output") {
            .just("output")
        }
    }

    func testFail() async throws {
        struct Failure: Error {}
        await AssertThrows(Failure.self) {
            Flow<Void>.fail(Failure())
        }
    }
}
