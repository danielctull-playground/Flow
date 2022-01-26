
public struct Flow<Output> {

    private let task: () async throws -> Output
    public init(_ task: @escaping () async throws -> Output) {
        self.task = task
    }

    public func callAsFunction() async throws -> Output {
        try await task()
    }
}

extension Flow {

    public func map<New>(
        _ transform: @escaping (Output) async throws -> New
    ) -> Flow<New> {
        Flow<New> {
            let output = try await self()
            return try await transform(output)
        }
    }

    public func flatMap<New>(
        _ transform: @escaping (Output) async throws -> Flow<New>
    ) -> Flow<New> {
        Flow<New> {
            let output = try await self()
            let flow = try await transform(output)
            return try await flow()
        }
    }
}

extension Flow {

    public func `catch`(
        _ transform: @escaping (Error) async throws -> Output
    ) -> Self {
        `catch`(Error.self, transform)
    }

    public func `catch`<E: Error>(
        _ error: E.Type,
        _ transform: @escaping (E) async throws -> Output
    ) -> Self {
        Flow {
            do {
                return try await self()
            } catch let error as E {
                return try await transform(error)
            } catch {
                throw error
            }
        }
    }

    public func mapError(
        _ transform: @escaping (Error) async -> Error
    ) -> Self {
        `catch` { throw await transform($0) }
    }

    public func mapError<E: Error>(
        _ error: E.Type,
        _ transform: @escaping (E) async -> Error
    ) -> Self {
        `catch`(E.self) { throw await transform($0) }
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
                do {
                    return try await self()
                } catch {}
            }
            return try await self()
        }
    }
}
