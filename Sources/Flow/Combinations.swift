
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
