import Foundation
import Keemun

extension ___VARIABLE_FeatureName___Feature {
    static let externalUpdate = Update<State, ExternalMsg, Effect> { msg, state in
        switch msg {
        }
        return .next(state) // FIXME: remove line
    }

    static let internalUpdate = Update<State, InternalMsg, Effect> { msg, state in
        switch msg {
        }
        return .next(state) // FIXME: remove line
    }

    enum ExternalMsg {
    }

    enum InternalMsg {
    }
}
