
import XCTest

func AssertThrowsError<E: Error, T>(
    _ error: E.Type,
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (E) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
    } catch let error as E {
        errorHandler(error)
    } catch {
        XCTFail("Expected error of type \(E.self) but found \(error) instead.")
    }
}
