import Foundation
import Combine
@testable import Keemun

func completenessStoreParams(repeatCount: Int) -> Keemun.StoreParams<CompletenessState, CompletenessMsg, CompletenessEffect> {
    return Keemun.StoreParams(
        start: Start {
            .next(
                .init(),
                effects: [
                    .startIncConter1(repeatCount: repeatCount),
                    .startIncConter2(repeatCount: repeatCount),
                    .startIncConter3(repeatCount: repeatCount)
                ]
            )
        },
        update: Update { msg, state in
            switch msg {
            case .incCounter1:
                return .next(state) { $0.counter1 += 1 }
            case .incCounter2:
                return .next(state) { $0.counter2 += 1 }
            case .incCounter3:
                return .next(state) { $0.counter3 += 1 }
            }
        },
        effectHandler: EffectHandler { effect in
            switch effect {
            case let .startIncConter1(repeatCount):
                return .publisher(
                    (1...repeatCount).publisher
                        .map { _ in .incCounter1 }
                        .eraseToAnyPublisher()
                )
                
            case let .startIncConter2(repeatCount):
                return .publisher(
                    (1...repeatCount).publisher
                        .map { _ in .incCounter2 }
                        .eraseToAnyPublisher()
                )
                
            case let .startIncConter3(repeatCount):
                return .publisher(
                    (1...repeatCount).publisher
                        .map { _ in .incCounter3 }
                        .eraseToAnyPublisher()
                )
            }
            
        }
    )
}

struct CompletenessState: Equatable {
    var counter1: Int = 0
    var counter2: Int = 0
    var counter3: Int = 0
}

enum CompletenessMsg {
    case incCounter1
    case incCounter2
    case incCounter3
}

enum CompletenessEffect {
    case startIncConter1(repeatCount: Int)
    case startIncConter2(repeatCount: Int)
    case startIncConter3(repeatCount: Int)
}
