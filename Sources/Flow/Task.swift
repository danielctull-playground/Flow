
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
