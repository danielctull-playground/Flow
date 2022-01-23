
public struct Flow<Output> {

    private let task: () async throws -> Output
    public init(_ task: @escaping () async throws -> Output) {
        self.task = task
    }

    public func callAsFunction() async throws -> Output {
        try await task()
    }
}
