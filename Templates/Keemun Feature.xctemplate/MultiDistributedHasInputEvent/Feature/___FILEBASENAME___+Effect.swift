import Combine
import Foundation
import Keemun

extension ___VARIABLE_FeatureName___Feature {
    static func effectHandler(
        input: AnyPublisher<InputEvent, Never>
    ) -> EffectHandler<Effect, InternalMsg> {
        EffectHandler { effect in
            switch effect {
            case .observeInputEvent:
                return .publisher(
                    input.map { event in event.convertToMsg() }
                        .eraseToAnyPublisher()
                )
            }
        }
    }

    enum Effect {
        case observeInputEvent
    }
}

fileprivate extension ___VARIABLE_FeatureName___Feature.InputEvent {
    func convertToMsg() -> ___VARIABLE_FeatureName___Feature.InternalMsg {
        switch self {
        }
    }
}
