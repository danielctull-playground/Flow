
import Flow
import XCTest

func AssertThrows<Output, E: Error>(
    _ error: E.Type,
    _ makeFlow: () -> Flow<Output>,
    validation : (E) -> Void = { _ in },
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        let flow = makeFlow()
        let output = try await flow()
        XCTFail("Expected error of type \(E.self) but found output \(output) instead.", file: file, line: line)
    } catch let error as E {
        validation(error)
    } catch {
        XCTFail("Expected error of type \(E.self) but found \(error) instead.", file: file, line: line)
    }
}

func AssertOutput<Output: Equatable>(
    _ expected: @autoclosure () -> Output,
    _ makeFlow: () -> Flow<Output>,
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        let flow = makeFlow()
        let output = try await flow()
        XCTAssertEqual(output, expected())
    } catch {
        XCTFail("Expected output \(expected()) but found \(error) instead.")
    }
}
