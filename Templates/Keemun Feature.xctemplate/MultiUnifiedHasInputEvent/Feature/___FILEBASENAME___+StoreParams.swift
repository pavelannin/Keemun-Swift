import Foundation
import Keemun

struct ___VARIABLE_FeatureName___Feature: KeemunFeature {
    let storeParams: StoreParams<State, Msg, Effect>

    init(effectHandler: EffectHandler<Effect, Msg>) {
        self.storeParams = StoreParams(
            start: Start {
                .next(
                    .init(),
                    effects: [
                        .observeInputEvent
                    ]
                )
            },
            update: Self.update,
            effectHandler: effectHandler
        )
    }
}

// MARK: - State
extension ___VARIABLE_FeatureName___Feature {
    struct State {
    }
}

// MARK: - Input Event
extension ___VARIABLE_FeatureName___Feature {
    enum InputEvent {
    }
}
