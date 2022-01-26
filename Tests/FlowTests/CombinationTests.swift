
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

    func testMerge2() async throws {
        let flow = a.merge(with: b)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
    }

    func testMerge2_failure() async throws {
        await AssertFlowThrowsError(fail.merge(with: b), Failure.self)
        await AssertFlowThrowsError(a.merge(with: fail), Failure.self)
    }

    func testMerge3() async throws {
        let flow = a.merge(with: b, c)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
    }

    func testMerge3_failure() async throws {
        await AssertFlowThrowsError(fail.merge(with: b, c), Failure.self)
        await AssertFlowThrowsError(a.merge(with: fail, c), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, fail), Failure.self)
    }

    func testMerge4() async throws {
        let flow = a.merge(with: b, c, d)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
    }

    func testMerge4_failure() async throws {
        await AssertFlowThrowsError(fail.merge(with: b, c, d), Failure.self)
        await AssertFlowThrowsError(a.merge(with: fail, c, d), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, fail, d), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, fail), Failure.self)
    }

    func testMerge5() async throws {
        let flow = a.merge(with: b, c, d, e)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
    }

    func testMerge5_failure() async throws {
        await AssertFlowThrowsError(fail.merge(with: b, c, d, e), Failure.self)
        await AssertFlowThrowsError(a.merge(with: fail, c, d, e), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, fail, d, e), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, fail, e), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, fail), Failure.self)
    }

    func testMerge6() async throws {
        let flow = a.merge(with: b, c, d, e, f)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
        XCTAssertEqual(output.5, "F")
    }

    func testMerge6_failure() async throws {
        await AssertFlowThrowsError(fail.merge(with: b, c, d, e, f), Failure.self)
        await AssertFlowThrowsError(a.merge(with: fail, c, d, e, f), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, fail, d, e, f), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, fail, e, f), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, fail, f), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, e, fail), Failure.self)
    }

    func testMerge7() async throws {
        let flow = a.merge(with: b, c, d, e, f, g)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
        XCTAssertEqual(output.5, "F")
        XCTAssertEqual(output.6, "G")
    }

    func testMerge7_failure() async throws {
        await AssertFlowThrowsError(fail.merge(with: b, c, d, e, f, g), Failure.self)
        await AssertFlowThrowsError(a.merge(with: fail, c, d, e, f, g), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, fail, d, e, f, g), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, fail, e, f, g), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, fail, f, g), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, e, fail, g), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, e, f, fail), Failure.self)
    }

    func testMerge8() async throws {
        let flow = a.merge(with: b, c, d, e, f, g, h)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
        XCTAssertEqual(output.5, "F")
        XCTAssertEqual(output.6, "G")
        XCTAssertEqual(output.7, "H")
    }

    func testMerge8_failure() async throws {
        await AssertFlowThrowsError(fail.merge(with: b, c, d, e, f, g, h), Failure.self)
        await AssertFlowThrowsError(a.merge(with: fail, c, d, e, f, g, h), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, fail, d, e, f, g, h), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, fail, e, f, g, h), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, fail, f, g, h), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, e, fail, g, h), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, e, f, fail, h), Failure.self)
        await AssertFlowThrowsError(a.merge(with: b, c, d, e, f, g, fail), Failure.self)
    }
}
