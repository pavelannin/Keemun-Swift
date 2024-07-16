import Combine
import Foundation
import Keemun

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
