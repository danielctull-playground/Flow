
import XCTest
import Flow

final class FlowTests: XCTestCase {

    func testPerform() async throws {
        var didPerform = false
        let flow = Flow { didPerform = true }
        try await flow()
        XCTAssert(didPerform)
    }
}
