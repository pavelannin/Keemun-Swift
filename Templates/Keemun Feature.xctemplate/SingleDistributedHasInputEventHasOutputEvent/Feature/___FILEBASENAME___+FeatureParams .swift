import Foundation
import Keemun

extension ___VARIABLE_FeatureName___Feature {
    var featureParams: FeatureParams<State, Msg, ViewState, ExternalMsg> {
        FeatureParams(
            viewStateTransform: StateTransform { state in
                ViewState()
            },
            messageTransform: Msg.up
        )
    }

// MARK: - View State
    struct ViewState {
    }
}
