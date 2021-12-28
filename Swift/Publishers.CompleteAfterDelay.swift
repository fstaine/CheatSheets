//
//  Publishers.CompleteAfterDelay.swift
//

import Foundation
import Combine

extension Publisher {

    ///
    ///     let pub = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    ///         .complete(after: .seconds(3), scheduler: DispatchQueue.main)
    ///     var sub: AnyCancellable?
    ///     DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
    ///         sub = pub.sink { _ in
    ///             print("completed")
    ///         } receiveValue: { value in
    ///             print("value at \(value)")
    ///         })
    ///     }
    ///
    ///     // Prints:
    ///     //   value at 2021-12-28 08:36:14 +0000
    ///     //   value at 2021-12-28 08:36:15 +0000
    ///     //   completed
    ///
    func complete<Context: Scheduler>(after delay: Context.SchedulerTimeType.Stride,
                                      scheduler: Context,
                                      options: Context.SchedulerOptions? = nil) -> Publishers.CompleteAfterDelay<Self, Context> {
        return Publishers.CompleteAfterDelay(upstream: self, delay: delay, scheduler: scheduler, options: options)
    }
}

extension Publishers {
    public struct CompleteAfterDelay<Upstream: Publisher, Context: Scheduler>: Publisher {
        public typealias Output = Upstream.Output
        public typealias Failure = Upstream.Failure
        
        public let upstream: Upstream
        public let scheduler: Context
        public let delay: Context.SchedulerTimeType.Stride
        public let options: Context.SchedulerOptions?

        init(upstream: Upstream, delay: Context.SchedulerTimeType.Stride, scheduler: Context, options: Context.SchedulerOptions?) {
            self.upstream = upstream
            self.delay = delay
            self.scheduler = scheduler
            self.options = options
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input {
            let inner = Inner(downstream: subscriber, delay: delay, scheduler: scheduler, options: options)
            self.upstream.subscribe(inner)
        }
    }
}

extension Publishers.CompleteAfterDelay {
    private class Inner<Downstream: Subscriber> : Subscriber, Subscription {
        
        typealias Input = Downstream.Input
        typealias Failure = Downstream.Failure
        
        private let downstream: Downstream
        
        private let delay: Context.SchedulerTimeType.Stride
        private let scheduler: Context
        private let options: Context.SchedulerOptions?
        
        private var subscription: Subscription?
        private var timer: AnyCancellable?
        
        let combineIdentifier = CombineIdentifier()
        
        init(downstream: Downstream, delay: Context.SchedulerTimeType.Stride, scheduler: Context, options: Context.SchedulerOptions?) {
            self.downstream = downstream
            self.delay = delay
            self.scheduler = scheduler
            self.options = options
        }
        
        func receive(subscription: Subscription) {
            if self.timer == nil {
                self.timer = self.delayExceededClock()
            }
            downstream.receive(subscription: subscription)
        }
        
        func receive(_ input: Downstream.Input) -> Subscribers.Demand {
            guard timer != nil else {
                return .none
            }
            scheduler.schedule(options: options) {
                let newDemand = self.downstream.receive(input)
                self.subscription?.request(newDemand)
            }
            return .none
        }
        
        func receive(completion: Subscribers.Completion<Downstream.Failure>) {
            guard timer != nil else {
                return
            }
            scheduler.schedule(options: options) {
                self.downstream.receive(completion: completion)
            }
            self.timer?.cancel()
            self.timer = nil
        }
        
        func request(_ demand: Subscribers.Demand) {
            if self.timer == nil {
                self.timer = self.delayExceededClock()
            }
            subscription?.request(demand)
        }
        
        func cancel() {
            timer?.cancel()
            self.timer = nil
            subscription?.cancel()
            subscription = nil
        }
        
        private func delayExceeded() {
            self.timer?.cancel()
            self.timer = nil
            subscription?.cancel()
            subscription = nil
            self.downstream.receive(completion: .finished)
        }
        
        private func delayExceededClock() -> AnyCancellable {
            let cancellable = scheduler.schedule(after: scheduler.now.advanced(by: self.delay),
                                                 interval: self.delay,
                                                 tolerance: scheduler.minimumTolerance,
                                                 options: self.options,
                                                 delayExceeded)
            return AnyCancellable(cancellable.cancel)
        }
    }
}
