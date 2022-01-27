
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
    
        await AssertThrows(Failure.self) { zip(fail, b) }
        await AssertThrows(Failure.self) { zip(a, fail) }
    }

    func testZip3() async throws {
        let flow = zip(a, b, c)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")

        await AssertThrows(Failure.self) { zip(fail, b, c) }
        await AssertThrows(Failure.self) { zip(a, fail, c) }
        await AssertThrows(Failure.self) { zip(a, b, fail) }
    }

    func testZip4() async throws {
        let flow = zip(a, b, c, d)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")

        await AssertThrows(Failure.self) { zip(fail, b, c, d) }
        await AssertThrows(Failure.self) { zip(a, fail, c, d) }
        await AssertThrows(Failure.self) { zip(a, b, fail, d) }
        await AssertThrows(Failure.self) { zip(a, b, c, fail) }
    }

    func testZip5() async throws {
        let flow = zip(a, b, c, d, e)
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")

        await AssertThrows(Failure.self) { zip(fail, b, c, d, e) }
        await AssertThrows(Failure.self) { zip(a, fail, c, d, e) }
        await AssertThrows(Failure.self) { zip(a, b, fail, d, e) }
        await AssertThrows(Failure.self) { zip(a, b, c, fail, e) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, fail) }
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

        await AssertThrows(Failure.self) { zip(fail, b, c, d, e, f) }
        await AssertThrows(Failure.self) { zip(a, fail, c, d, e, f) }
        await AssertThrows(Failure.self) { zip(a, b, fail, d, e, f) }
        await AssertThrows(Failure.self) { zip(a, b, c, fail, e, f) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, fail, f) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, e, fail) }
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

        await AssertThrows(Failure.self) { zip(fail, b, c, d, e, f, g) }
        await AssertThrows(Failure.self) { zip(a, fail, c, d, e, f, g) }
        await AssertThrows(Failure.self) { zip(a, b, fail, d, e, f, g) }
        await AssertThrows(Failure.self) { zip(a, b, c, fail, e, f, g) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, fail, f, g) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, e, fail, g) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, e, f, fail) }
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

        await AssertThrows(Failure.self) { zip(fail, b, c, d, e, f, g, h) }
        await AssertThrows(Failure.self) { zip(a, fail, c, d, e, f, g, h) }
        await AssertThrows(Failure.self) { zip(a, b, fail, d, e, f, g, h) }
        await AssertThrows(Failure.self) { zip(a, b, c, fail, e, f, g, h) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, fail, f, g, h) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, e, fail, g, h) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, e, f, fail, h) }
        await AssertThrows(Failure.self) { zip(a, b, c, d, e, f, g, fail) }
    }
}
