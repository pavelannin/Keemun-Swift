import Foundation
import Keemun

struct ___VARIABLE_FeatureName___Feature: KeemunFeature {
    typealias Msg = PairMsg<ExternalMsg, InternalMsg>

    let storeParams: StoreParams<State, Msg, Effect>

    init(effectHandler: EffectHandler<Effect, InternalMsg>) {
        self.storeParams = StoreParams(
            start: Start { .next(.init()) },
            update: .combine(
                externalUpdate: Self.externalUpdate,
                internalUpdate: Self.internalUpdate
            ),
            effectHandler: effectHandler
        )
    }
}

// MARK: - State
extension ___VARIABLE_FeatureName___Feature {
    struct State {
    }
}
