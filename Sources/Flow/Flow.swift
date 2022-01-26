
public struct Flow<Output> {

    private let task: () async throws -> Output

    public init(_ task: @escaping () async throws -> Output) {
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
