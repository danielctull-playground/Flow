
extension Task where Failure == Never {

    public static func just(_ success: Success) -> Self {
        .init { success }
    }
}

extension Task where Failure == Error {

    public static func just(_ success: Success) -> Self {
        .init { success }
    }

    public static func fail(_ failure: Failure) -> Self {
        .init { throw failure }
    }
}

// MARK: - Transformations

extension Task where Failure == Error {

    public func map<NewSuccess>(
        _ transform: @escaping (Success) -> NewSuccess
    ) -> Task<NewSuccess, Failure> {
        .init { try await transform(value) }
    }

    public func flatMap<NewSuccess>(
        _ transform: @escaping (Success) -> Task<NewSuccess, Failure>
    ) -> Task<NewSuccess, Failure> {
        .init {
            let task = try await transform(value)
            return try await task.value
        }
    }
}
