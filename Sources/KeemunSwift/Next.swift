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

// MARK: - Mutable state
public extension Next {
    typealias MutableState<Value> = (inout Value) -> Void

    @available(*, deprecated, message: "Use MutableState instead")
    typealias Mutable<Value> = (inout Value) -> Void

    static func next(_ state: State, with: MutableState<State>) -> Next<State, Effect> {
        var mutable = state
        with(&mutable)
        return self.init(state: mutable, effects: [])
    }
    
    static func next(_ state: State, effects: [Effect], with: MutableState<State>) -> Next<State, Effect> {
        var mutable = state
        with(&mutable)
        return self.init(state: mutable, effects: effects)
    }
    
    static func next(_ state: State, effect: Effect, with: MutableState<State>) -> Next<State, Effect> {
        var mutable = state
        with(&mutable)
        return self.init(state: mutable, effects: [effect])
    }
}

// MARK: - Mutable state with effects
public extension Next {
    typealias MutableStateEffects<Value> = (inout Value, inout [Effect]) -> Void

    static func next(
        _ state: State,
        effects: [Effect] = [],
        with: MutableStateEffects<State>
    ) -> Next<State, Effect> {
        var mutableState = state
        var mutableEffects = effects
        with(&mutableState, &mutableEffects)
        return self.init(state: mutableState, effects: mutableEffects)
    }
}
