import Foundation

public struct PairMsg<ExternalMsg, InternalMsg> {
    public let anyMsg: AnyMsg
    
    public init(external msg: ExternalMsg) {
        self.anyMsg = .externalMsg(msg)
    }
    
    public init(internal msg: InternalMsg) {
        self.anyMsg = .internalMsg(msg)
    }
    
    public enum AnyMsg {
        case externalMsg(ExternalMsg)
        case internalMsg(InternalMsg)
    }
}

public extension PairMsg {
    static func up(_ value: ExternalMsg) -> PairMsg<ExternalMsg, InternalMsg> {
        return self.init(external: value)
    }
    
    static func up(_ value: InternalMsg) -> PairMsg<ExternalMsg, InternalMsg> {
        return self.init(internal: value)
    }
}

public extension Update {
    static func combine<ExternalMsg, InternalMsg>(
        externalUpdate: Update<State, ExternalMsg, Effect>,
        internalUpdate: Update<State, InternalMsg, Effect>
    ) -> Update<State, PairMsg<ExternalMsg, InternalMsg>, Effect> {
        return .init { msg, state in
            switch msg.anyMsg {
            case let .externalMsg(externalMsg):
                externalUpdate.run(externalMsg, state)
                
            case let .internalMsg(internalMsg):
                internalUpdate.run(internalMsg, state)
            }
        }
    }
}

public extension StoreParams {
    init<ExternalMsg, InternalMsg>(
        start: Start<State, Effect>,
        update: Update<State, Msg, Effect>,
        effectHandlers: [EffectHandler<Effect, InternalMsg>]
    ) where Msg == PairMsg<ExternalMsg, InternalMsg> {
        self.init(
            start: start,
            update: update,
            effectHandlers: effectHandlers.map { $0.map(PairMsg<ExternalMsg, InternalMsg>.up) }
        )
    }
    
    init<ExternalMsg, InternalMsg>(
        start: Start<State, Effect>,
        update: Update<State, Msg, Effect>,
        effectHandler: EffectHandler<Effect, InternalMsg>
    ) where Msg == PairMsg<ExternalMsg, InternalMsg> {
        self.init(
            start: start,
            update: update,
            effectHandler: effectHandler.map(PairMsg<ExternalMsg, InternalMsg>.up)
        )
    }
}
