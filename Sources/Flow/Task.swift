
extension Task where Failure == Never {

    public static func just(_ success: Success) -> Self {
        .init { success }
    }
}

extension Task where Failure == Error {

    public static func just(_ success: Success) -> Self {
        .init { success }
    }

    public static func fail(_ failure: Failure) -> Self {
        .init { throw failure }
    }
}

// MARK: - Transformations

extension Task where Failure == Error {

    public func map<NewSuccess>(
        _ transform: @escaping (Success) -> NewSuccess
    ) -> Task<NewSuccess, Failure> {
        .init { try await transform(value) }
    }

    public func flatMap<NewSuccess>(
        _ transform: @escaping (Success) -> Task<NewSuccess, Failure>
    ) -> Task<NewSuccess, Failure> {
        .init {
            let task = try await transform(value)
            return try await task.value
        }
    }
}

// MARK: - Error Handling

extension Task where Failure == Error {

    public func `catch`(
        _ transform: @escaping (Error) -> Self
    ) -> Self {
        `catch`(Error.self, transform)
    }

    public func `catch`<E: Error>(
        _ error: E.Type,
        _ transform: @escaping (E) -> Self
    ) -> Self {
        .init {
            do {
                return try await value
            } catch let error as E {
                let task = transform(error)
                return try await task.value
            } catch {
                throw error
            }
        }
    }

    public func mapError(
        _ transform: @escaping (Error) -> Error
    ) -> Self {
        `catch` { .fail(transform($0)) }
    }

    public func mapError<E: Error>(
        _ error: E.Type,
        _ transform: @escaping (E) -> Error
    ) -> Self {
        `catch`(E.self) { .fail(transform($0)) }
    }

    /// Attempts to perform the task given number of times.
    ///
    /// - Parameter attempts: The number of times to attempt the ``task``.
    /// - Returns: A flow that attempts to perform the ``task`` the given number
    ///            of times.
    public func retry(_ attempts: Int) -> Self {
        guard attempts > 0 else { fatalError("Require attempts of at least 1") }
        guard attempts > 1 else { return self }
        return .init {
            for _ in 1...attempts-1 {
                guard let value = try? await value else { continue }
                return value
            }
            return try await value
        }
    }
}
