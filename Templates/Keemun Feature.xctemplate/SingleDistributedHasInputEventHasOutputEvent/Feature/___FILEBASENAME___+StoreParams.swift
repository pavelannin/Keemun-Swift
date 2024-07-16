import Combine
import Foundation
import Keemun

struct ___VARIABLE_FeatureName___Feature: KeemunFeature {
    typealias Msg = PairMsg<ExternalMsg, InternalMsg>

    let storeParams: StoreParams<State, Msg, Effect>

    init(effectHandler: EffectHandler<Effect, InternalMsg>) {
        self.storeParams = StoreParams(
            start: Start {
                .next(
                    .init(),
                    effects: [
                        .observeInputEvent
                    ]
                )
            },
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

// MARK: - Effects
extension ___VARIABLE_FeatureName___Feature {
    static func effectHandler(
        input: AnyPublisher<InputEvent, Never>,
        output: @escaping (OutputEvent) -> Void
    ) -> EffectHandler<Effect, InternalMsg> {
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
    func convertToMsg() -> ___VARIABLE_FeatureName___Feature.InternalMsg {
        switch self {
        }
    }
}
