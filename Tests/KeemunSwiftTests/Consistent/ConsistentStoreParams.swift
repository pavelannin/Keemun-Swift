import Foundation
@testable import Keemun

func consistentStoreParams() -> Keemun.StoreParams<ConsistentState, ConsistentMsg, ConsistentEffect> {
    return Keemun.StoreParams(
        start: Start { .next(.init(progress: false, loadedUser: nil)) },
        update: Update { msg, state in
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
        },
        effectHandler: EffectHandler { effect in
            switch effect {
            case .loadUser(id: let id):
                return .task { dispatch in
                    let user = await loadUserById(id: id)
                    dispatch(.userWasLoaded(user: user))
                }
            }
        }
    )
}

private func loadUserById(id: Int) async -> ConsistentState.User {
    return .init(id: id)
}

struct ConsistentState: Equatable {
    var progress: Bool
    var loadedUser: User?
    
    struct User: Equatable {
        let id: Int
    }
}

enum ConsistentMsg {
    case loadUserById(id: Int)
    case userWasLoaded(user: ConsistentState.User)
}

enum ConsistentEffect: Equatable {
    case loadUser(id: Int)
}
