import Combine
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
        input: AnyPublisher<InputEvent, Never>,
        output: @escaping (OutputEvent) -> Void
    ) -> EffectHandler<Effect, Msg> {
        EffectHandler { effect in
            switch effect {
            case .observeInputEvent:
                return .publisher(
                    input.map { event in event.convertToMsg() }
                        .eraseToAnyPublisher()
                )

            case let .sendOutputEvent(event):
                output(event)
                return .publisher(Empty().eraseToAnyPublisher())
            }
        }
    }

    enum Effect {
        case observeInputEvent
        case sendOutputEvent(OutputEvent)
    }
}

fileprivate extension ___VARIABLE_FeatureName___Feature.InputEvent {
    func convertToMsg() -> ___VARIABLE_FeatureName___Feature.Msg {
        switch self {
        }
    }
}
