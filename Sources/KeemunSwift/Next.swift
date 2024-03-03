import Foundation

public struct Next<State, Effect> {
    public let state: State
    public let effects: [Effect]
    
    public init(state: State, effects: [Effect]) {
        self.state = state
        self.effects = effects
    }
}

public extension Next {
    static func next(_ state: State) -> Next<State, Effect> {
        return self.init(state: state, effects: [])
    }
    
    static func next(_ state: State, effects: [Effect]) -> Next<State, Effect> {
        return self.init(state: state, effects: effects)
    }
    
    static func next(_ state: State, effect: Effect) -> Next<State, Effect> {
        return self.init(state: state, effects: [effect])
    }
}

public extension Next {
    typealias Mutable<Value> = (inout Value) -> Void
    
    static func next(_ state: State, with: Mutable<State>) -> Next<State, Effect> {
        var mutable = state
        with(&mutable)
        return self.init(state: mutable, effects: [])
    }
    
    static func next(_ state: State, effects: [Effect], with:  Mutable<State>) -> Next<State, Effect> {
        var mutable = state
        with(&mutable)
        return self.init(state: mutable, effects: effects)
    }
    
    static func next(_ state: State, effect: Effect, with:  Mutable<State>) -> Next<State, Effect> {
        var mutable = state
        with(&mutable)
        return self.init(state: mutable, effects: [effect])
    }
}
