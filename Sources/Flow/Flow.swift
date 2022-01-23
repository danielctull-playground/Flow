
public struct Flow<Input, Output> {

    private let task: (Input) async throws -> Output
    public init(_ task: @escaping (Input) async throws -> Output) {
        self.task = task
    }

    public func callAsFunction(_ input: Input) async throws -> Output {
        try await task(input)
    }
}

extension Flow where Input == Void {

    public func callAsFunction() async throws -> Output {
        try await task(())
    }
}

extension Flow {

    public func map<New>(
        _ transform: @escaping (Output) async throws -> New
    ) -> Flow<Input, New> {
        Flow<Input, New> { input in
            let output = try await self(input)
            return try await transform(output)
        }
    }
}

extension Flow {

    public func `catch`(
        _ handler: @escaping (Error) async throws -> Output
    ) -> Self {
        `catch`(Error.self, handler)
    }

    public func `catch`(
        _ handler: @escaping () async throws -> Output
    ) -> Self {
        `catch`(Error.self) { _ in try await handler() }
    }

    public func `catch`<E: Error>(
        _ error: E.Type,
        _ handler: @escaping (E) async throws -> Output
    ) -> Self {
        Flow { input in
            do {
                return try await self(input)
            } catch let error as E {
                return try await handler(error)
            } catch {
                throw error
            }
        }
    }

    public func `catch`<E: Error>(
        _ error: E.Type,
        _ handler: @escaping () async throws -> Output
    ) -> Self {
        Flow { input in
            do {
                return try await self(input)
            } catch is E {
                return try await handler()
            } catch {
                throw error
            }
        }
    }

    public func mapError(
        _ handler: @escaping (Error) async -> Error
    ) -> Self {
        `catch` { throw await handler($0) }
    }

    public func mapError<E: Error>(
        _ error: E.Type,
        _ handler: @escaping (E) async -> Error
    ) -> Self {
        `catch`(E.self) { throw await handler($0) }
    }
    
    /// Attempts to perform the task given number of times.
    ///
    /// - Parameter attempts: The number of times to attempt the ``task``.
    /// - Returns: A flow that attempts to perform the ``task`` the given number
    ///            of times.
    public func retry(_ attempts: Int) -> Self {
        guard attempts > 0 else { fatalError("Require attempts of at least 1") }
        guard attempts > 1 else { return self }
        return Flow { input in
            for _ in 1...attempts-1 {
                do {
                    return try await self(input)
                } catch {}
            }
            return try await self(input)
        }
    }
}
