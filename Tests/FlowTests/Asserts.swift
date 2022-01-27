
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

func AssertSuccess<Success: Equatable, Failure>(
    _ task: @autoclosure () -> Task<Success, Failure>,
    _ expected: @autoclosure () -> Success,
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        let value = try await task().value
        XCTAssertEqual(value, expected(), file: file, line: line)
    } catch {
        XCTFail("Unexpected failure \(error).", file: file, line: line)
    }
}

func AssertFailure<Success, Failure: Error>(
    _ task: @autoclosure () -> Task<Success, Error>,
    _ failure: @autoclosure () -> Failure.Type,
    validation : (Failure) -> Void = { _ in },
    file: StaticString = #filePath,
    line: UInt = #line
) async {

    do {
        let value = try await task().value
        XCTFail("Expected error of type \(Failure.self) but received a value of \(value) instead.", file: file, line: line)
    } catch let failure as Failure {
        validation(failure)
    } catch {
        XCTFail("Expected error of type \(Failure.self) but found \(error) instead.", file: file, line: line)
    }
}
