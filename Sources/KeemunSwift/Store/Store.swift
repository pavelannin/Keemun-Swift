import Foundation
import Combine

/// The entity controls all entities and initiates the message processing and side effect mechanism.
public final class Store<State, Msg, Effect> {
    private let params: StoreParams<State, Msg, Effect>
    
    private let _state: CurrentValueSubject<State, Never>
    
    private let _messages = PassthroughSubject<Msg, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    public var currentState: State { self._state.value }
    public let state: AnyPublisher<State, Never>
    
    public init(_ params: StoreParams<State, Msg, Effect>) {
        self.params = params
        
        let startNext = self.params.start.run()
        let defaultState = startNext.state
        let startEffects = startNext.effects
        
        self._state = CurrentValueSubject(defaultState)
        self.state = self._state.eraseToAnyPublisher()
        
        let observeMessagesQueue = DispatchQueue(label: "keemun.observeMessagesQueue", qos: .userInitiated)
        self._messages
            .receive(on: observeMessagesQueue)
            .buffer(size: .max, prefetch: .keepFull, whenFull: .dropOldest)
            .sink { msg in self.observeMessages(state: self._state.value, msg: msg) }
            .store(in: &self.cancellables)
        self.effectProcess(startEffects, dispatch: self.dispatch)
    }
    
    /// Sending messages asynchronously.
    public func dispatch(_ msg: Msg) {
        _messages.send(msg)
    }
    
    private func observeMessages(state: State, msg: Msg) {
        let next = self.params.update.run(msg, state)
        self._state.send(next.state)
        effectProcess(next.effects, dispatch: self.dispatch)
    }
    
    private func effectProcess(_ effects: [Effect], dispatch: @escaping Dispatch<Msg>) {
        for effectHandler in self.params.effectHandlers {
            for effect in effects {
                switch effectHandler.processing(effect) {
                case let .publisher(anyPublisher):
                    anyPublisher
                        .sink(receiveValue: dispatch)
                        .store(in: &cancellables)
                    
                case let .task(priority, operation):
                    Task(priority: priority) {
                        await operation(dispatch)
                    }
                }
            }
        }
    }
}
