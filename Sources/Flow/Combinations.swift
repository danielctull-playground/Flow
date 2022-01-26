
extension Flow {

    public func merge<A>(
        with flowA: Flow<A>
    ) -> Flow<(Output, A)> {
        Flow<(Output, A)> {
            async let output = self()
            async let a = flowA()
            return try await (output, a)
        }
    }
}
