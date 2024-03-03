import Foundation
import Combine
import Dispatch

/// The entity controls all entities and initiates the message processing and side effect mechanism.
public final class Store<State, Msg, Effect> {
    private let starter: any StartType<State, Effect>
    private let updater: any UpdateType<State, Msg, Effect>
    private let effectHandlers: [any EffectHandlerType<Effect, Msg>]
    
    private let _state: CurrentValueSubject<State, Never>
    
    private let _messages: PassthroughSubject = PassthroughSubject<Msg, Never>()
    private var cancellable: Set<AnyCancellable> = []
    
    public var currentState: State { self._state.value }
    public let state: AnyPublisher<State, Never>
    
    public init(_ storeParams: StoreParams<State, Msg, Effect>) {
        self.starter = storeParams.start
        self.updater = storeParams.update
        self.effectHandlers = storeParams.effectHandlers
        
        let startNext = self.starter.start()
        
        self._state = CurrentValueSubject(startNext.state)
        self.state = self._state.eraseToAnyPublisher()
        self._messages
            .handleEvents(receiveSubscription: { _ in self.process(startNext.effects, dispatch: self.dispatch) })
            .buffer(size: .max, prefetch: .keepFull, whenFull: .dropOldest)
            .sink { msg in self.observeMessages(state: self._state.value, msg: msg) }
            .store(in: &self.cancellable)
    }
    
    private func observeMessages(state: State, msg: Msg) {
        let next = self.updater.update(for: msg, state: state)
        self._state.send(next.state)
        self.process(next.effects, dispatch: self.dispatch)
    }
    
    /// Sending messages asynchronously.
    public func dispatch(_ msg: Msg) {
        _messages.send(msg)
    }
    
    private func observeMessages(state: State, msg: Msg) {
        let next = self.params.update.run(msg, state)
        self._state.send(next.state)
        self.params.effectHandlers.forEach { $0.process(next.effects, dispatch: self.dispatch) }
    }
    
    func process(_ effects: [Effect], dispatch: @escaping Dispatch<Msg>) {
        for effectHandler in self.params.effectHandlers {
            for effect in effects {
                switch effectHandler.processing(effect) {
                case let .publisher(anyPublisher):
                    anyPublisher
                    
                case let .task(priority, operation):
                    <#code#>
                }
            }
        }
    }
}
