
import XCTest
import Flow

final class CombinationTests: XCTestCase {

    func testMerge2() async throws {
        let flow = Flow.just("A")
            .merge(with: .just("B"))
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
    }

    func testMerge3() async throws {
        let flow = Flow.just("A")
            .merge(with: .just("B"), .just("C"))
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
    }

    func testMerge4() async throws {
        let flow = Flow.just("A")
            .merge(with: .just("B"), .just("C"), .just("D"))
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
    }

    func testMerge5() async throws {
        let flow = Flow.just("A")
            .merge(with: .just("B"), .just("C"), .just("D"), .just("E"))
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
    }

    func testMerge6() async throws {
        let flow = Flow.just("A")
            .merge(with: .just("B"), .just("C"), .just("D"), .just("E"), .just("F"))
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
        XCTAssertEqual(output.5, "F")
    }

    func testMerge7() async throws {
        let flow = Flow.just("A")
            .merge(with: .just("B"), .just("C"), .just("D"), .just("E"), .just("F"), .just("G"))
        let output = try await flow()
        XCTAssertEqual(output.0, "A")
        XCTAssertEqual(output.1, "B")
        XCTAssertEqual(output.2, "C")
        XCTAssertEqual(output.3, "D")
        XCTAssertEqual(output.4, "E")
        XCTAssertEqual(output.5, "F")
        XCTAssertEqual(output.6, "G")
    }

    func testMerge8() async throws {
        let flow = Flow.just("A")
            .merge(with: .just("B"), .just("C"), .just("D"), .just("E"), .just("F"), .just("G"), .just("H"))
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
}
