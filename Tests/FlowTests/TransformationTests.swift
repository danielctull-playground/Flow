
import XCTest
import Flow

final class FlowTransformationTests: XCTestCase {

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
}

final class TaskTransformationTests: XCTestCase {

    func testMap() async throws {
        let task = Task<Int, Error>
            .just(4)
            .map(String.init)
        await AssertSuccess(task, "4")
    }
}
