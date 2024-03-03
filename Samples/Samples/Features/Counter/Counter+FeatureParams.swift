import Foundation
import Keemun

extension CounterFeature {
    var featureParams: FeatureParams<State, Msg, ViewState, ExternalMsg> {
        FeatureParams(
            viewStateTransform: StateTransform { state in
                ViewState(
                    syncCount: String(state.syncCount),
                    asyncCount: String(state.asyncCount),
                    isAsyncRunning: state.isAsyncRunning
                )
            }, 
            messageTransform: Msg.up
        )
    }
    
    struct ViewState {
        let syncCount: String
        let asyncCount: String
        let isAsyncRunning: Bool
    }
}
