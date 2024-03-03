import Foundation
import SwiftUI

public protocol StoreParams<State, Msg, Effect> {
    associatedtype State
    associatedtype Msg
    associatedtype Effect
    associatedtype Body: StoreParams
    
    var start: Start<State, Effect> { get }
    var update: Update<State, Msg, Effect> { get }
    var effectHandlers: [AnyEffectHandler<Effect, Msg>] { get }
    
    @StoreParamsBuilder<State, Msg, Effect>
    var body: Body { get }
}

//public extension StoreParams where Body == Never {
//    var body: Body { fatalError("'\(Self.self)' has no body.") }
//}

public struct DefaultStoreParams<State, Msg, Effect>: StoreParams {
    public typealias State = <#type#>
    
    public typealias Msg = <#type#>
    
    public typealias Effect = <#type#>
    
    public typealias Body = <#type#>
    
    public let start: Start<State, Effect>
    public let update: Update<State, Msg, Effect>
    public let effectHandlers: [AnyEffectHandler<Effect, Msg>]
    
    public init(start: Start<State, Effect>, update: Update<State, Msg, Effect>, effectHandlers: [AnyEffectHandler<Effect, Msg>]) {
        self.start = start
        self.update = update
        self.effectHandlers = effectHandlers
    }
}

public extension StoreParams where Body == DefaultStoreParams<State, Msg, Effect> {
    var start: Start<State, Effect> { self.body.start }
    var update: Update<State, Msg, Effect> { self.body.update }
    var effectHandlers: [AnyEffectHandler<Effect, Msg>] { self.body.effectHandlers }
}

@resultBuilder
public enum StoreParamsBuilder<State, Msg, Effect> {
//    public static func buildBlock(_ storeParams: some StoreParams) -> some StoreParams {
//        return storeParams
//    }
    
    public static func buildBlock(_ storeParams: DefaultStoreParams<State, Msg, Effect>, in: Int) -> DefaultStoreParams<State, Msg, Effect> {
        return storeParams
    }
}


class Asd: StoreParams {
    typealias State = String
    typealias Msg = Int
    typealias Effect = Int
    
    var body: some StoreParams {
        
    }
}
struct ContentView: View {
     var body: some View {
         // This is inside a result builder
         VStack {
             Text("Hello World!") // VStack and Text are 'build blocks'
         }
     }

//public struct StoreParams<State, Msg, Effect>: StoreParamsType {
//    public let start: any StartType<State, Effect>
//    public let update: any UpdateType<State, Msg, Effect>
//    public let effectHandlers: [any EffectHandlerType<Effect, Msg>]
//    
//    public init(
//        start: some StartType<State, Effect>,
//        update: some UpdateType<State, Msg, Effect>,
//        effectHandlers: [any EffectHandlerType<Effect, Msg>]
//    ) {
//        self.start = start
//        self.update = update
//        self.effectHandlers = effectHandlers
//    }
//}
//
//public extension StoreParams {
//    init(
//        start: some StartType<State, Effect>,
//        update: some UpdateType<State, Msg, Effect>,
//        effectHandler: some EffectHandlerType<Effect, Msg>
//    ) {
//        self.start = start
//        self.update = update
//        self.effectHandlers = [effectHandler]
//    }
//    
//    init(
//        start: @escaping Start<State, Effect>.ClosureType,
//        update: @escaping Update<State, Msg, Effect>.ClosureType,
//        effectHandlers: [any EffectHandlerType<Effect, Msg>]
//    ) {
//        self.start = Start<State, Effect>(start)
//        self.update = Update<State, Msg, Effect>(update)
//        self.effectHandlers = effectHandlers
//    }
//    
//    init(
//        start: @escaping Start<State, Effect>.ClosureType,
//        update: @escaping Update<State, Msg, Effect>.ClosureType,
//        effectHandlers: some EffectHandlerType<Effect, Msg>
//    ) {
//        self.start = Start<State, Effect>(start)
//        self.update = Update<State, Msg, Effect>(update)
//        self.effectHandlers = [effectHandlers]
//    }
//}
//
//public extension StoreParamsType where Body == StoreParams<State, Msg, Effect> {
//    var start: Start<State, Effect> { self.body.start }
//    var update: Update<State, Msg, Effect> { self.body.update }
//    var effectHandlers: [EffectHandler<Effect, Msg>] { self.body.effectHandlers }
//}
