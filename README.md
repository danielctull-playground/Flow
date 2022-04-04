# Flow

Flow provides the benefits of a chaining type like Combine’s `Publisher` or the Swift standard library’s `AsyncSequence`, but with the guarantee that only one value will come through the chain.

It also provides a nice place to “host” a function that can be used to retrieve a result through a series of complicated steps, as one can extend Flow and provide a static property for the implementation of the flow.

## Example

A complicated flow of tasks can become burdensome when multiple types of error can be thrown and different recovery functions can be performed with these errors to maintain the [successful mainline](https://fsharpforfunandprofit.com/rop/).

```swift
struct FailureA: Error {}
struct FailureB: Error {}
struct ValueA {}
struct ValueB {}

// Can throw FailureA and FailureB
func valueA() async throws -> ValueA {
    if Bool.random() {
        return ValueA()
    } else if Bool.random() {
        throw FailureA()
    } else {
        throw FailureB()
    }
}

// Can throw FailureB
func recoverFromFailureA(_ failure: FailureA) async throws -> ValueA {
    if Bool.random() {
        return ValueA()
    } else {
        throw FailureB()
    }
}

func recoverFromFailureB(_ failure: FailureB) async throws -> ValueA {
    ValueA()
}

func processValue(_ value: ValueA) async -> ValueB {
    ValueB()
}
```

To chain these functions with conventional do/catch, we could nest one do/catch block in another.

```swift
func valueB() async throws -> ValueB {

    do {
        do {
            let valueA = try await valueA()
            return await processValue(valueA)
        } catch let error as FailureA {
            let valueA = try await recoverFromFailureA(error)
            return await processValue(valueA)
        }
    } catch let error as FailureB {
        let valueA = try await recoverFromFailureB(error)
        return await processValue(valueA)
    } catch {
        throw error
    }
}
```

Already we can see that with a more complicated set of recovery functions, this will start to get pretty hectic. The above is a simple example, in the previous app I worked on we had multiple errors which could be recovered from resulting in requiring four nested do/catch blocks and some recovery functions to be duplicated among them.

With `Flow`, upstream failures are caught and resolutions are attempted to pass the value on the next step, in a similar way to reactive programming. This allows code to be easier read and reasoned about, as well as allowing even more complicated procedures to be written in a simple fashion, such as retrying a step multiple times to find success.

```swift 
extension Flow where Output == ValueB {

    static var valueB: Self {

        Flow<ValueA> {
            try await valueA()
        }
        .catch(FailureA.self) { failureA in
            Flow<ValueA> { try await recoverFromFailureA(failureA) }
        }
        .catch(FailureB.self) { failureB in
            Flow<ValueA> { try await recoverFromFailureB(failureB) }
        }
        .flatMap { valueA in
            Flow { await processValue(valueA) }
        }
    }
}

func flowValueB() async throws -> ValueB {
    try await Flow.valueB()
}
``` 
