
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
