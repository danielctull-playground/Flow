
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
        Flow { input in
            do {
                return try await self(input)
            } catch {
                return try await handler(error)
            }
        }
    }
}
