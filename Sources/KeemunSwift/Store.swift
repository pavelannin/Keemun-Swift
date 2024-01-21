import Foundation
import Combine
import Dispatch

/// The entity controls all entities and initiates the message processing and side effect mechanism.
public final class Store<Params: StoreParams> {
    public typealias State = Params.State
    public typealias Msg = Params.Msg
    public typealias Effect = Params.Effect
    public typealias Dispatch = Params.Dispatch
    
    private let params: Params
    private let _state: CurrentValueSubject<State, Never>
    
    private let _messages: PassthroughSubject = PassthroughSubject<Msg, Never>()
    private var cancellable: Set<AnyCancellable> = []
    
    public var currentState: State { self._state.value }
    public let state: AnyPublisher<State, Never>
    
    public init(_ storeParams: Params) {
        self.params = storeParams
        
        let startNext = self.params.start()
        
        self._state = CurrentValueSubject(startNext.state)
        self.state = self._state.eraseToAnyPublisher()
        self._messages
            .handleEvents(receiveSubscription: { _ in self.process(startNext.effects) { msg in self.dispatch(msg) } })
            .buffer(size: .max, prefetch: .keepFull, whenFull: .dropOldest)
            .sink { msg in self.observeMessages(state: self._state.value, msg: msg) }
            .store(in: &self.cancellable)
    }
    
    private func observeMessages(state: State, msg: Msg) {
        let next = Params.update(for: msg, state: state)
        self._state.send(next.state)
        self.process(next.effects) { msg in self.dispatch(msg) }
    }
    
    /// Sending messages asynchronously.
    public func dispatch(_ msg: Msg) {
        _messages.send(msg)
    }
    
    private func process(_ effects: [Effect], priority: TaskPriority? = .medium, dispatch: @escaping Dispatch) {
        for effect in effects {
            Task(priority: priority) { await params.effectHandler(for: effect, dispatch: dispatch) }
        }
    }
}

public extension StoreParams {
    /// Creates a new instance of `Store` from `StoreParams`.
    func makeStore() -> Store<Self> {
        return Store<Self>(self)
    }
}
