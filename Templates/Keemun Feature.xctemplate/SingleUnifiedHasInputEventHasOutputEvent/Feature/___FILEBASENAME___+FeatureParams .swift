import Foundation
import Keemun

extension ___VARIABLE_FeatureName___Feature {
    var featureParams: FeatureParams<State, Msg, ViewState, Msg> {
        FeatureParams(
            StateTransform { state in
                ViewState()
            }
        )
    }

// MARK: - View State
    struct ViewState {
    }
}
