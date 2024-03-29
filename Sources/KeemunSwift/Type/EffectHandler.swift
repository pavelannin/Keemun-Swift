import Combine
import Dispatch
import Foundation

public typealias Dispatch<Msg> = (Msg) -> Void

public struct EffectHandler<Effect, Msg> {
    public let processing: (Effect) -> Operation<Msg>
    
    public init(_ processing: @escaping (Effect) -> Operation<Msg>) {
        self.processing = processing
    }
    
    public enum Operation<Msg> {
        case publisher(AnyPublisher<Msg, Never>)
        case task(TaskPriority? = nil, @Sendable (Dispatch<Msg>) async -> Void)
    }
}

public extension EffectHandler {
    func map<OutMsg>(_ transform: @escaping (Msg) -> OutMsg) -> EffectHandler<Effect, OutMsg> {
        return EffectHandler<Effect, OutMsg> { effect in
            switch self.processing(effect) {
            case let .publisher(anyPublisher):
                return .publisher(
                    anyPublisher
                        .map(transform)
                        .eraseToAnyPublisher()
                )
                
            case let .task(priority, operation):
                return .task(priority) { dispatch in
                    await operation { msg in dispatch(transform(msg))}
                }
            }
        }
    }
}
