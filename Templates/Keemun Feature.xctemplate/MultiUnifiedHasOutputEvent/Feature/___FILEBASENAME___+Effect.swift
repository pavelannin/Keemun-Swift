import Combine
import Foundation
import Keemun

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
