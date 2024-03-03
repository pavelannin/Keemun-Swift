import Foundation
import SwiftUI

public struct StoreParams<State, Msg, Effect> {
    public let start: Start<State, Effect>
    public let update: Update<State, Msg, Effect>
    public let effectHandlers: [EffectHandler<Effect, Msg>]
    
    public init(
        start: Start<State, Effect>,
        update: Update<State, Msg, Effect>,
        effectHandlers: [EffectHandler<Effect, Msg>]
    ) {
        self.start = start
        self.update = update
        self.effectHandlers = effectHandlers
    }
}

public extension StoreParams {
    init(
        start: Start<State, Effect>,
        update: Update<State, Msg, Effect>,
        effectHandler: EffectHandler<Effect, Msg>
    ) {
        self.init(
            start: start,
            update: update,
            effectHandlers: [effectHandler]
        )
    }
}
