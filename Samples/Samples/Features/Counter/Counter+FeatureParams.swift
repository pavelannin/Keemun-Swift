import Foundation
import Keemun

struct CounterFeatureParams: FeatureParams {
    typealias SParams = CounterStoreParams
}

extension CounterFeatureParams {
    func stateTransform(_ state: CounterStoreParams.State) -> ViewState {
        ViewState(
            syncCount: String(state.syncCount),
            asyncCount: String(state.asyncCount),
            isAsyncRunning: state.isAsyncRunning
        )
    }
    
    struct ViewState {
        let syncCount: String
        let asyncCount: String
        let isAsyncRunning: Bool
    }
}
