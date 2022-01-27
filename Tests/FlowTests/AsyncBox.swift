
actor AsyncBox<Value> {
    init(_ value: Value) { self.value = value }
    var value: Value
}

extension AsyncBox where Value: Numeric {
    func increment() { value += 1 }
}
