import Foundation
import Keemun

struct ___VARIABLE_FeatureName___Feature: KeemunFeature {
    let storeParams: StoreParams<State, Msg, Effect>

    init(effectHandler: EffectHandler<Effect, Msg>) {
        self.storeParams = StoreParams(
            start: Start { .next(.init())},
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

// MARK: - Msg
extension ___VARIABLE_FeatureName___Feature {
    static let update = Update<State, Msg, Effect> { msg, state in
        switch msg {
        }
        return .next(state) // FIXME: remove line
    }

    enum Msg {
    }
}

// MARK: - Effects
extension ___VARIABLE_FeatureName___Feature {
    static func effectHandler() -> EffectHandler<Effect, Msg> {
        EffectHandler { effect in
            switch effect {
            }
        }
    }

    enum Effect {
    }
}
