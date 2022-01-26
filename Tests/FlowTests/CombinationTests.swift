
import XCTest
import Flow

final class CombinationTests: XCTestCase {

    private struct Failure: Error {}
    private let fail = Flow<Void>.fail(Failure())
    private let a = Flow.just("A")
    private let b = Flow.just("B")
    private let c = Flow.just("C")
    private let d = Flow.just("D")
    private let e = Flow.just("E")
    private let f = Flow.just("F")
    private let g = Flow.just("G")
    private let h = Flow.just("H")

    func testZip2() async throws {
        let flow = zip(a, b)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
    
        await AssertFlowThrowsError(zip(fail, b), Failure.self)
        await AssertFlowThrowsError(zip(a, fail), Failure.self)
    }

    func testZip3() async throws {
        let flow = zip(a, b, c)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")

        await AssertFlowThrowsError(zip(fail, b, c), Failure.self)
        await AssertFlowThrowsError(zip(a, fail, c), Failure.self)
        await AssertFlowThrowsError(zip(a, b, fail), Failure.self)
    }

    func testZip4() async throws {
        let flow = zip(a, b, c, d)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")

        await AssertFlowThrowsError(zip(fail, b, c, d), Failure.self)
        await AssertFlowThrowsError(zip(a, fail, c, d), Failure.self)
        await AssertFlowThrowsError(zip(a, b, fail, d), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, fail), Failure.self)
    }

    func testZip5() async throws {
        let flow = zip(a, b, c, d, e)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")

        await AssertFlowThrowsError(zip(fail, b, c, d, e), Failure.self)
        await AssertFlowThrowsError(zip(a, fail, c, d, e), Failure.self)
        await AssertFlowThrowsError(zip(a, b, fail, d, e), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, fail, e), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, fail), Failure.self)
    }

    func testZip6() async throws {
        let flow = zip(a, b, c, d, e, f)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
        XCTAssertEqual(output.5, "F")

        await AssertFlowThrowsError(zip(fail, b, c, d, e, f), Failure.self)
        await AssertFlowThrowsError(zip(a, fail, c, d, e, f), Failure.self)
        await AssertFlowThrowsError(zip(a, b, fail, d, e, f), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, fail, e, f), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, fail, f), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, e, fail), Failure.self)
    }

    func testZip7() async throws {
        let flow = zip(a, b, c, d, e, f, g)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
        XCTAssertEqual(output.5, "F")
        XCTAssertEqual(output.6, "G")

        await AssertFlowThrowsError(zip(fail, b, c, d, e, f, g), Failure.self)
        await AssertFlowThrowsError(zip(a, fail, c, d, e, f, g), Failure.self)
        await AssertFlowThrowsError(zip(a, b, fail, d, e, f, g), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, fail, e, f, g), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, fail, f, g), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, e, fail, g), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, e, f, fail), Failure.self)
    }

    func testZip8() async throws {
        let flow = zip(a, b, c, d, e, f, g, h)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
        XCTAssertEqual(output.5, "F")
        XCTAssertEqual(output.6, "G")
        XCTAssertEqual(output.7, "H")

        await AssertFlowThrowsError(zip(fail, b, c, d, e, f, g, h), Failure.self)
        await AssertFlowThrowsError(zip(a, fail, c, d, e, f, g, h), Failure.self)
        await AssertFlowThrowsError(zip(a, b, fail, d, e, f, g, h), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, fail, e, f, g, h), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, fail, f, g, h), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, e, fail, g, h), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, e, f, fail, h), Failure.self)
        await AssertFlowThrowsError(zip(a, b, c, d, e, f, g, fail), Failure.self)
    }
}
