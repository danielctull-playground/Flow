
extension Flow {

    public func `catch`(
        _ transform: @escaping (Error) -> Flow<Output>
    ) -> Self {
        `catch`(Error.self, transform)
    }

    public func `catch`<E: Error>(
        _ error: E.Type,
        _ transform: @escaping (E) -> Flow<Output>
    ) -> Self {
        Flow {
            do {
                return try await self()
            } catch let error as E {
                let flow = transform(error)
                return try await flow()
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
        return Flow {
            for _ in 1...attempts-1 {
                guard let output = try? await self() else { continue }
                return output
            }
            return try await self()
        }
    }
}
