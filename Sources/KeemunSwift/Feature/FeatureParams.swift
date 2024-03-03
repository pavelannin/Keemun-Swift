import Foundation

public struct FeatureParams<State, Msg, ViewState, ExternalMsg> {
    let viewStateTransform: any StateTransform<Statte, ViewState>
    let externalMessageTransform: (ExternalMsg) -> Msg
    
    ini
}
/// This protocol describes the required parameters for creating a `KeemunConnector`.
public protocol FeatureParams {
    
    /// Store parameters.
    associatedtype SParams: StoreParams
    
    /// The type of state of the user view.
    associatedtype ViewState
    
    /// The type of messages that will be sent from the user view.
    associatedtype ExternalMsg
    
    /// The queue in which the conversion of `State` to `ViewState` will take place.
    static var stateTransformScheduler: DispatchQueue { get }
    
    /// Transformation `ViewState` from the feature `State`.
    func stateTransform(_ state: SParams.State) -> ViewState
    
    /// Mapper`ExternalMsg` to `Msg`.
    static func msgMapper(_ msg: ExternalMsg) -> SParams.Msg
}

public extension FeatureParams {
    static var stateTransformScheduler: DispatchQueue {
        return DispatchQueue(label: "io.github.pavelannin.keemun.stateTransformScheduler", qos: .userInitiated)
    }
}

public extension FeatureParams where SParams.State == ViewState {
    static func stateTransform(_ state: SParams.State) async -> ViewState {
        return state
    }
}

public extension FeatureParams where ExternalMsg == SParams.Msg {
    static func msgMapper(_ msg: ExternalMsg) -> SParams.Msg {
        return msg
    }
}

public extension FeatureParams where SParams: MsgSplitable, SParams.Msg == SplitMsg<SParams.ExternalMsg, SParams.InternalMsg> {
    static func msgMapper(_ msg: SParams.ExternalMsg) -> SParams.Msg {
        return .init(msg)
    }
}
