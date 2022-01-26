
extension Flow {

    public func merge<B>(
        with flowB: Flow<B>
    ) -> Flow<(Output, B)> {
        Flow<(Output, B)> {
            async let output = self()
            async let b = flowB()
            return try await (output, b)
        }
    }

    public func merge<B, C>(
        with flowB: Flow<B>,
        _ flowC: Flow<C>
    ) -> Flow<(Output, B, C)> {
        Flow<(Output, B, C)> {
            async let output = self()
            async let b = flowB()
            async let c = flowC()
            return try await (output, b, c)
        }
    }

    public func merge<B, C, D>(
        with flowB: Flow<B>,
        _ flowC: Flow<C>,
        _ flowD: Flow<D>
    ) -> Flow<(Output, B, C, D)> {
        Flow<(Output, B, C, D)> {
            async let output = self()
            async let b = flowB()
            async let c = flowC()
            async let d = flowD()
            return try await (output, b, c, d)
        }
    }

    public func merge<B, C, D, E>(
        with flowB: Flow<B>,
        _ flowC: Flow<C>,
        _ flowD: Flow<D>,
        _ flowE: Flow<E>
    ) -> Flow<(Output, B, C, D, E)> {
        Flow<(Output, B, C, D, E)> {
            async let output = self()
            async let b = flowB()
            async let c = flowC()
            async let d = flowD()
            async let e = flowE()
            return try await (output, b, c, d, e)
        }
    }

    public func merge<B, C, D, E, F>(
        with flowB: Flow<B>,
        _ flowC: Flow<C>,
        _ flowD: Flow<D>,
        _ flowE: Flow<E>,
        _ flowF: Flow<F>
    ) -> Flow<(Output, B, C, D, E, F)> {
        Flow<(Output, B, C, D, E, F)> {
            async let output = self()
            async let b = flowB()
            async let c = flowC()
            async let d = flowD()
            async let e = flowE()
            async let f = flowF()
            return try await (output, b, c, d, e, f)
        }
    }

    public func merge<B, C, D, E, F, G>(
        with flowB: Flow<B>,
        _ flowC: Flow<C>,
        _ flowD: Flow<D>,
        _ flowE: Flow<E>,
        _ flowF: Flow<F>,
        _ flowG: Flow<G>
    ) -> Flow<(Output, B, C, D, E, F, G)> {
        Flow<(Output, B, C, D, E, F, G)> {
            async let output = self()
            async let b = flowB()
            async let c = flowC()
            async let d = flowD()
            async let e = flowE()
            async let f = flowF()
            async let g = flowG()
            return try await (output, b, c, d, e, f, g)
        }
    }


    public func merge<B, C, D, E, F, G, H>(
        with flowB: Flow<B>,
        _ flowC: Flow<C>,
        _ flowD: Flow<D>,
        _ flowE: Flow<E>,
        _ flowF: Flow<F>,
        _ flowG: Flow<G>,
        _ flowH: Flow<H>
    ) -> Flow<(Output, B, C, D, E, F, G, H)> {
        Flow<(Output, B, C, D, E, F, G, H)> {
            async let output = self()
            async let b = flowB()
            async let c = flowC()
            async let d = flowD()
            async let e = flowE()
            async let f = flowF()
            async let g = flowG()
            async let h = flowH()
            return try await (output, b, c, d, e, f, g, h)
        }
    }
}
