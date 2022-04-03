
import XCTest
import Flow

final class TransformationTests: XCTestCase {

    func testMap() async throws {
        await AssertOutput("4") {
            Flow.just(4)
                .map(String.init)
        }
    }

    func testFlatMap() async throws {
        await AssertOutput("4") {
            Flow.just(4)
                .flatMap { value in
                    Flow { String(value) }
                }
        }
    }
}
