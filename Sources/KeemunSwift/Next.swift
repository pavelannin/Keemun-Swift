import Foundation

/// Protocol containing data that should be applied next.
protocol Next {
    associatedtype State
    associatedtype Effect
    
    /// The state that will be applied.
    var state: State { get }
    
    /// A collection of side-effects that will be triggered.
    var effects: [Effect] { get }
}

// MARK: - Start

/// Contains the default state value of the state and a collection of initial side effects.
///
/// For example:
///
///     .next(State())
///     .next(State(), effect: Effect())
///     .next(State(), effects: [Effect()])
public struct Start<Types: StoreTypes>: Next {
    public typealias State = Types.State
    public typealias Effect = Types.Effect
    
    /// Default state value.
    public let state: State
    
    ///Collection of initial side effects.
    public let effects: [Effect]
    
    private init(state: State, effects: [Effect]) {
        self.state = state
        self.effects = effects
    }
}

public extension Start {
    /// Creaate `Start`.
    /// - Parameter state: The initial value of the state.
    /// - Parameter effects: A collection of initial side effects.
    static func next(_ state: State, effects: [Effect] = []) -> Start<Types> {
        return .init(state: state, effects: effects)
    }
    
    /// Creaate `Start`.
    /// - Parameter state: The initial value of the state.
    /// - Parameter effects: Initial side effect.
    static func next(_ state: State, effect: Effect) -> Start<Types> {
        return .init(state: state, effects: [effect])
    }
}

public extension Start where Effect == Void{
    
    /// Creaate `Start`.
    /// - Parameter state: The initial value of the state.
    static func next(_ state: State) -> Start<Types> {
        return .init(state: state, effects: [])
    }
}

// MARK: - Update

/// Updates the state and triggers the execution of side effects.
///
///For example:
///
///     .next(State())
///     .next(State()) { state in state.value = newValue }
///     .next(State(), effect: Effect())
///     .next(State(), effect: Effect()) { state in state.value = newValue }
///     .next(State(), effects: [Effect()])
///     .next(State(), effects: [Effect()]) { state in state.value = newValue }
public struct Update<Types: StoreTypes>: Next {
    public typealias State = Types.State
    public typealias Effect = Types.Effect
    
    /// New value of the state.
    public let state: State
    
    /// Collection of side effects to be triggered.
    public let effects: [Effect]
    
    private init(state: State, effects: [Effect]) {
        self.state = state
        self.effects = effects
    }
}

public extension Update {
    typealias MutateState = (inout State) -> Void
    
    /// Creaate `Update`.
    /// - Parameter state: The new value of the state.
    /// - Parameter effects: A collection of side effects to be triggered.
    static func next(_ state: State, effects: [Effect] = []) -> Update<Types> {
        return .init(state: state, effects: effects)
    }
    
    /// Creaate `Update`.
    /// - Parameter state: The new value of the state.
    /// - Parameter effect: Side effect to be triggered.
    static func next(_ state: State, effect: Effect) -> Update<Types> {
        return .init(state: state, effects: [effect])
    }
    
    /// Creaate `Update`.
    /// - Parameter state: The new value of the state.
    /// - Parameter effects: A collection of side effects to be triggered.
    /// - Parameter with: A closure that mutates the state before applying it.
    static func next(_ state: State, effects: [Effect] = [], with: MutateState) -> Update<Types> {
        var mutable = state
        with(&mutable)
        return .init(state: mutable, effects: effects)
    }
    
    /// Creaate `Update`.
    /// - Parameter state: The new value of the state.
    /// - Parameter effect: Side effect to be triggered.
    /// - Parameter with: A closure that mutates the state before applying it.
    static func next(_ state: State, effect: Effect, with: MutateState) -> Update<Types> {
        return .next(state, effects: [effect], with: with)
    }
}

public extension Update where Effect == Void {
    
    /// Creaate `Update`.
    /// - Parameter state: The new value of the state.
    static func next(_ state: State) -> Update<Types> {
        return .init(state: state, effects: [])
    }
    
    /// Creaate `Update`.
    /// - Parameter state: The new value of the state.
    /// - Parameter with: A closure that mutates the state before applying it.
    static func next(_ state: State, with: MutateState) -> Update<Types> {
        var mutable = state
        with(&mutable)
        return .init(state: mutable, effects: [])
    }
}
