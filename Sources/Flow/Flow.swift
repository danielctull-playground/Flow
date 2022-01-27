
public struct Flow<Output> {

    private let task: @Sendable () async throws -> Output

    public init(_ task: @escaping @Sendable () async throws -> Output) {
        self.task = task
    }

    public static func just(_ output: Output) -> Self {
        Flow { output }
    }

    public static func fail(_ error: Error) -> Self {
        Flow { throw error }
    }

    public func callAsFunction() async throws -> Output {
        try await task()
    }
}

// MARK: - Transformations

extension Flow {

    public func map<New>(
        _ transform: @escaping (Output) -> New
    ) -> Flow<New> {
        Flow<New> {
            let output = try await self()
            return transform(output)
        }
    }

    public func flatMap<New>(
        _ transform: @escaping (Output) -> Flow<New>
    ) -> Flow<New> {
        Flow<New> {
            let output = try await self()
            let flow = transform(output)
            return try await flow()
        }
    }
}

// MARK: - Error Handling

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

// MARK: - Combinations

public func zip<A, B>(
    _ flowA: Flow<A>,
    _ flowB: Flow<B>
) -> Flow<(A, B)> {
    Flow {
        async let a = flowA()
        async let b = flowB()
        return try await (a, b)
    }
}

public func zip<A, B, C>(
    _ flowA: Flow<A>,
    _ flowB: Flow<B>,
    _ flowC: Flow<C>
) -> Flow<(A, B, C)> {
    Flow {
        async let a = flowA()
        async let b = flowB()
        async let c = flowC()
        return try await (a, b, c)
    }
}

public func zip<A, B, C, D>(
    _ flowA: Flow<A>,
    _ flowB: Flow<B>,
    _ flowC: Flow<C>,
    _ flowD: Flow<D>
) -> Flow<(A, B, C, D)> {
    Flow {
        async let a = flowA()
        async let b = flowB()
        async let c = flowC()
        async let d = flowD()
        return try await (a, b, c, d)
    }
}

public func zip<A, B, C, D, E>(
    _ flowA: Flow<A>,
    _ flowB: Flow<B>,
    _ flowC: Flow<C>,
    _ flowD: Flow<D>,
    _ flowE: Flow<E>
) -> Flow<(A, B, C, D, E)> {
    Flow {
        async let a = flowA()
        async let b = flowB()
        async let c = flowC()
        async let d = flowD()
        async let e = flowE()
        return try await (a, b, c, d, e)
    }
}

public func zip<A, B, C, D, E, F>(
    _ flowA: Flow<A>,
    _ flowB: Flow<B>,
    _ flowC: Flow<C>,
    _ flowD: Flow<D>,
    _ flowE: Flow<E>,
    _ flowF: Flow<F>
) -> Flow<(A, B, C, D, E, F)> {
    Flow {
        async let a = flowA()
        async let b = flowB()
        async let c = flowC()
        async let d = flowD()
        async let e = flowE()
        async let f = flowF()
        return try await (a, b, c, d, e, f)
    }
}

public func zip<A, B, C, D, E, F, G>(
    _ flowA: Flow<A>,
    _ flowB: Flow<B>,
    _ flowC: Flow<C>,
    _ flowD: Flow<D>,
    _ flowE: Flow<E>,
    _ flowF: Flow<F>,
    _ flowG: Flow<G>
) -> Flow<(A, B, C, D, E, F, G)> {
    Flow {
        async let a = flowA()
        async let b = flowB()
        async let c = flowC()
        async let d = flowD()
        async let e = flowE()
        async let f = flowF()
        async let g = flowG()
        return try await (a, b, c, d, e, f, g)
    }
}

public func zip<A, B, C, D, E, F, G, H>(
    _ flowA: Flow<A>,
    _ flowB: Flow<B>,
    _ flowC: Flow<C>,
    _ flowD: Flow<D>,
    _ flowE: Flow<E>,
    _ flowF: Flow<F>,
    _ flowG: Flow<G>,
    _ flowH: Flow<H>
) -> Flow<(A, B, C, D, E, F, G, H)> {
    Flow {
        async let a = flowA()
        async let b = flowB()
        async let c = flowC()
        async let d = flowD()
        async let e = flowE()
        async let f = flowF()
        async let g = flowG()
        async let h = flowH()
        return try await (a, b, c, d, e, f, g, h)
    }
}
