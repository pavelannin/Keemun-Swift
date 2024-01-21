import Foundation
@testable import KeemunSwift

struct ConsistentStoreParams: StoreParams {
    func start() -> Start<Self> {
        return .next(.init(progress: false, loadedUser: nil))
    }
    
    static func update(for msg: Msg, state: State) -> Update<Self> {
        switch msg {
        case .loadUserById(id: let id):
            return .next(state, effect: .loadUser(id: id)) { mutableState in
                mutableState.progress = true
            }
            
        case .userWasLoaded(user: let user):
            return .next(state) { mutableState in
                mutableState.progress = false
                mutableState.loadedUser = user
            }
        }
    }
    
    func effectHandler(for effect: Effect, dispatch: @escaping (Msg) -> Void) async {
        switch effect {
        case .loadUser(id: let id):
            let user = await Self.loadUserById(id: id)
            dispatch(.userWasLoaded(user: user))
        }
    }
    
    private static func loadUserById(id: Int) async -> State.User {
        return .init(id: id)
    }
    
    struct State: Equatable {
        var progress: Bool
        var loadedUser: User?
        
        struct User: Equatable {
            let id: Int
        }
    }
    
    enum Msg {
        case loadUserById(id: Int)
        case userWasLoaded(user: State.User)
    }
    
    enum Effect: Equatable {
        case loadUser(id: Int)
    }
}
