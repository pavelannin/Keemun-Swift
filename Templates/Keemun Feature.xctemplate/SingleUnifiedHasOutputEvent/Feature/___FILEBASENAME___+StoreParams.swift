import Combine
import Foundation
import Keemun

struct ___VARIABLE_FeatureName___Feature: KeemunFeature {
    let storeParams: StoreParams<State, Msg, Effect>

    init(effectHandler: EffectHandler<Effect, Msg>) {
        self.storeParams = StoreParams(
            start: Start { .next(.init()) },
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

// MARK: - Output Event
extension ___VARIABLE_FeatureName___Feature {
    enum OutputEvent {
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
    static func effectHandler(
        output: @escaping (OutputEvent) -> Void
    ) -> EffectHandler<Effect, Msg> {
        EffectHandler { effect in
            switch effect {
            case let .sendOutputEvent(event):
                output(event)
                return .publisher(Empty().eraseToAnyPublisher())
            }
        }
    }

    enum Effect {
        case sendOutputEvent(OutputEvent)
    }
}
