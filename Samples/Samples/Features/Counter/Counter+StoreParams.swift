import Combine
import Foundation
import Keemun

struct CounterFeature: KeemunFeature {
    typealias Msg = PairMsg<ExternalMsg, InternalMsg>
    
    var storeParams: StoreParams<State, Msg, Effect> {
        StoreParams(
            start: Start { .next(.init())},
            update: .combine(
                externalUpdate: Self.externalUpdate,
                internalUpdate: Self.internalUpdate
            ),
            effectHandler: Self.effectHandler()
        )
    }
}

extension CounterFeature {
    struct State {
        var syncCount: Int = 0
        var asyncCount: Int = 0
        var isAsyncRunning: Bool = false
    }
}

extension CounterFeature {
    static let externalUpdate = Update<State, ExternalMsg, Effect> { msg, state in
        switch msg {
        case .incrementSync:
            return .next(state) { $0.syncCount = $0.syncCount + 1 }

        case .decrementSync:
            return .next(state) { $0.syncCount = $0.syncCount - 1 }

        case .incrementAsync:
            return .next(state) { state, effects in
                guard !state.isAsyncRunning else { return }
                state.isAsyncRunning = true
                effects.append(.increment(state.asyncCount))
            }

        case .decrementAsync:
            return .next(state) { state, effects in
                guard !state.isAsyncRunning else { return }
                state.isAsyncRunning = true
                effects.append(.decrement(state.asyncCount))
            }
        }
    }
    
    static let internalUpdate = Update<State, InternalMsg, Effect> { msg, state in
        switch msg {
        case .completedAsyncOperation(let newValue):
            return .next(state) {
                $0.asyncCount = newValue
                $0.isAsyncRunning = false
            }
        }
    }
    
    enum ExternalMsg {
        case incrementSync
        case decrementSync
        case incrementAsync
        case decrementAsync
    }
    
    enum InternalMsg{
        case completedAsyncOperation(Int)
    }
}

extension CounterFeature {
    static func effectHandler() -> EffectHandler<Effect, InternalMsg> {
        EffectHandler { effect in
            switch effect {
            case .increment(let value):
                return .task { dispatch in
                    try! await Task.sleep(for: .seconds(1))
                    dispatch(.completedAsyncOperation(value + 1))
                }
                
            case .decrement(let value):
                return .task { dispatch in
                    try! await Task.sleep(for: .seconds(1))
                    dispatch(.completedAsyncOperation(value - 1))
                }
            }
        }
    }
    
    enum Effect {
        case increment(Int)
        case decrement(Int)
    }
}
