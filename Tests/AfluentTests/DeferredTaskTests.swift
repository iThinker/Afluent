import ConcurrencyExtras
import Testing

@testable import Afluent

struct AfluentTests {
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test func deferredTaskDoesNotExecuteImmediately() async throws {
        actor Test {
            var fired = false
            func fire() { fired = true }
        }
        let test = Test()

        _ = DeferredTask {
            await test.fire()
        }

        try await Task.sleep(for: .milliseconds(1))
        let fired = await test.fired

        #expect(!fired)
    }

    @Test func deferredTaskExecutesWhenAskedTo() async throws {
        await withCheckedContinuation { continuation in
            DeferredTask {
                continuation.resume()
            }.run()
        }
    }

    @Test func deferredTaskCancelledWithinCancelledTask_WithExecute() async throws {
        await #expect(throws: CancellationError.self) {
            try await withMainSerialExecutor {
                let cancelledSubject = SingleValueSubject<Void>()

                let task = Task {
                    try await DeferredTask {
                        try await cancelledSubject.execute()
                        try Task.checkCancellation()
                    }.execute()
                }

                await Task.yield()
                task.cancel()
                try cancelledSubject.send()

                try await task.value
            }
        }
    }

    @Test func deferredTaskCancelledWithinCancelledTask_WithResult() async throws {
        await #expect(throws: CancellationError.self) {
            try await withMainSerialExecutor {
                let cancelledSubject = SingleValueSubject<Void>()

                let task = Task {
                    try await DeferredTask {
                        try await cancelledSubject.execute()
                        try Task.checkCancellation()
                    }.result.get()
                }

                await Task.yield()
                task.cancel()
                try cancelledSubject.send()

                try await task.value
            }
        }
    }
}
