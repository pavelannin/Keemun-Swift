import Foundation

/// The basic protocol describes the types used for the `Store`.
public protocol StoreTypes {
    
    /// The type of the state.
    associatedtype State
    
    /// The type of the processed messages.
    associatedtype Msg
    
    ///The type of the triggered side effects.
    associatedtype Effect
    
    /// Dispatches a message to the runtime.
    typealias Dispatch = (Msg) -> Void
}

/// This protocol describes the required parameters for creating a `Store`.
///
/// For example:
///
///     struct MyStoreParams: StoreParams {
///         typealias State =
///         typealias Msg =
///         typealias Effect =
///
///         func start() -> Start<MyStoreParams> {
///             .next(State())
///         }
///
///         static func update(for msg: Msg, state: State) -> Update<MyStoreParams> {
///             .next(state)
///         }
///
///         func effectHandler(for effect: Effect, dispatch: @escaping Dispatch) async {
///             dispatch(...)
///         }
///     }
public protocol StoreParams: StoreTypes {
    
    /// Returns default state and effects.
    func start() -> Start<Self>
    
    /// Creates a next state and side-effects from a message and current state.
    static func update(for msg: Msg, state: State) -> Update<Self>
    
    /// Handling `effect` and `dispatch` messages.
    func effectHandler(for effect: Effect, dispatch: @escaping Dispatch) async
}

// MARK: - Update: Distribute

// The wrapper that distributes `Msg` to external and internal components.
public struct SplitMsg<ExternalMsg, InternalMsg> {
    
    /// The value of the message.
    public let value: AnyMsg
    
    public init(_ msg: ExternalMsg) {
        self.value = .externalMsg(msg)
    }
    
    public init(_ msg: InternalMsg) {
        self.value = .internalMsg(msg)
    }
    
    public enum AnyMsg {
        case externalMsg(ExternalMsg)
        case internalMsg(InternalMsg)
    }
}

/// The protocol that extends the capabilities of `StoreParams` by distributing `Msg` into external and internal types.
///
/// For example:
///
///     struct MyStoreParams: StoreParams, MsgSplitable {
///         typealias State =
///         typealias ExternalMsg =
///         typealias InternalMsg =
///         typealias Msg = SplitMsg<ExternalMsg, InternalMsg>
///         typealias Effect =
///
///         func start() -> Start<MyStoreParams> {
///             .next(State())
///         }
///
///         static func externalUpdate(for msg: ExternalMsg, state: State) -> Update<MyStoreParams> {
///             .next(state)
///         }
///
///         static func internalUpdate(for msg: InternalMsg, state: State) -> Update<MyStoreParams> {
///             .next(state)
///         }
///
///         func effectHandler(for effect: Effect, dispatch: @escaping InternalDispatch) async {
///             dispatch(...)
///         }
///     }
public protocol MsgSplitable: StoreTypes {
    associatedtype ExternalMsg
    associatedtype InternalMsg
    
    /// Dispatches a Internal message to the runtime.
    typealias InternalDispatch = (InternalMsg) -> Void
    
    /// Creates a next state and side-effects from a external message and current state.
    static func externalUpdate(for msg: ExternalMsg, state: State) -> Update<Self>
    
    /// Creates a next state and side-effects from a internal message and current state.
    static func internalUpdate(for msg: InternalMsg, state: State) -> Update<Self>
    
    /// Handling `effect` and `dispatch` internal messages.
    func effectHandler(for effect: Effect, dispatch: @escaping InternalDispatch) async
}

public extension MsgSplitable where Msg == SplitMsg<ExternalMsg, InternalMsg> {
    
    /// Override the `StoreParams` method to call the distributed methods `externalUpdate` and `internalUpdate`.
    static func update(for msg: Msg, state: State) -> Update<Self> {
        switch msg.value {
        case .externalMsg(let value):
            return externalUpdate(for: value, state: state)
        case .internalMsg(let value):
            return internalUpdate(for: value, state: state)
        }
    }
    
    /// Override the `StoreParams` method to call the method for `InternalDispatch`.
    func effectHandler(for effect: Effect, dispatch: @escaping Dispatch) async {
        await effectHandler(for: effect, dispatch: { dispatch(.init($0)) })
    }
}
