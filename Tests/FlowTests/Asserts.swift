
import Flow
import XCTest

private func AssertThrowsError<E: Error, T>(
    _ error: E.Type,
    task: () async throws -> T,
    validation : (E) -> Void = { _ in },
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        _ = try await task()
        XCTFail("Expected error of type \(E.self) but got success instead.")
    } catch let error as E {
        validation(error)
    } catch {
        XCTFail("Expected error of type \(E.self) but found \(error) instead.")
    }
}

func AssertFlowThrowsError<Output, E: Error>(
    _ flow: Flow<Output>,
    _ error: E.Type,
    validation : (E) -> Void = { _ in },
    file: StaticString = #filePath,
    line: UInt = #line
) async {

    await AssertThrowsError(
        E.self,
        task: { try await flow() },
        validation: validation,
        file: file,
        line: line)
}
