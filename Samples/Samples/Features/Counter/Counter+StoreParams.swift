import Foundation
import KeemunSwift

struct CounterStoreParams: StoreParams, MsgSplitable {
    func start() -> Start<CounterStoreParams> {
        .next(
            .init(
                syncCount: 0,
                asyncCount: 0,
                isAsyncRunning: false
            )
        )
    }
}

extension CounterStoreParams {
    struct State {
        var syncCount: Int
        var asyncCount: Int
        var isAsyncRunning: Bool
    }
}

extension CounterStoreParams {
    typealias Msg = SplitMsg<ExternalMsg, InternalMsg>
    
    public static func externalUpdate(for msg: ExternalMsg, state: State) -> Update<CounterStoreParams> {
        switch msg {
        case .incrementSync:
            return .next(state) { $0.syncCount = $0.syncCount + 1 }
        case .decrementSync:
            return .next(state) { $0.syncCount = $0.syncCount - 1 }
        case .incrementAsync:
            return .next(state, effect: .increment(state.asyncCount)) { $0.isAsyncRunning = true }
        case .decrementAsync:
            return .next(state, effect: .decrement(state.asyncCount)) { $0.isAsyncRunning = true }
        }
    }
    
    static func internalUpdate(for msg: InternalMsg, state: State) -> KeemunSwift.Update<CounterStoreParams> {
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

extension CounterStoreParams {
    func effectHandler(for effect: Effect, dispatch: @escaping InternalDispatch) async {
        switch effect {
        case .increment(let value):
            try! await Task.sleep(for: .seconds(1))
            dispatch(.completedAsyncOperation(value + 1))
        case .decrement(let value):
            try! await Task.sleep(for: .seconds(1))
            dispatch(.completedAsyncOperation(value - 1))
        }
    }
    
    enum Effect {
        case increment(Int)
        case decrement(Int)
    }
}
