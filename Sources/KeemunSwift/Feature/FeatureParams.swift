import Foundation

public struct FeatureParams<State, Msg, ViewState, ExternalMsg> {
    public let viewStateTransform: StateTransform<State, ViewState>
    public let messageTransform: (ExternalMsg) -> Msg
    
    public init(
        viewStateTransform: StateTransform<State, ViewState>,
        messageTransform: @escaping (ExternalMsg) -> Msg
    ) {
        self.viewStateTransform = viewStateTransform
        self.messageTransform = messageTransform
    }
}

public extension FeatureParams where Msg == ExternalMsg {
    init(_ viewStateTransform: StateTransform<State, ViewState>) {
        self.init(viewStateTransform: viewStateTransform, messageTransform: { $0 })
    }
}

public extension FeatureParams where State == ViewState {
    init(_ messageTransform: @escaping (ExternalMsg) -> Msg) {
        self.init(viewStateTransform: StateTransform { $0 }, messageTransform: messageTransform)
    }
}

public extension FeatureParams where State == ViewState, Msg == ExternalMsg {
    init() {
        self.init(viewStateTransform: StateTransform { $0 }, messageTransform: { $0 })
    }
}
