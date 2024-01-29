import XCTest
import Combine
@testable import Keemun

final class ConsistentTest: XCTestCase {
    private var cancellable: Set<AnyCancellable> = []
    
    func testUpdater1() throws {
        let userId = 101
        let defaultState = ConsistentStoreParams.State(progress: false, loadedUser: nil)
        let msg = ConsistentStoreParams.Msg.loadUserById(id: userId)
        let next = ConsistentStoreParams.update(for: msg, state: defaultState)
        XCTAssertEqual(next.state, ConsistentStoreParams.State(progress: true, loadedUser: nil))
        XCTAssertEqual(next.effects, [ConsistentStoreParams.Effect.loadUser(id: userId)])
    }
    
    func testUpdater2() throws {
        let defaultState = ConsistentStoreParams.State(progress: true, loadedUser: nil)
        let user = ConsistentStoreParams.State.User(id: 101)
        let msg = ConsistentStoreParams.Msg.userWasLoaded(user: user)
        let next = ConsistentStoreParams.update(for: msg, state: defaultState)
        XCTAssertEqual(next.state, ConsistentStoreParams.State(progress: false, loadedUser: user))
        XCTAssertEqual(next.effects, [])
    }
    
    func testFull() throws {
        let expectation = self.expectation(description: "Waiting for the result to be received")
        let store = ConsistentStoreParams().makeStore()
        var actual: [ConsistentStoreParams.State] = []
        store.state
            .collect(3)
            .first()
            .sink {
                actual = $0
                expectation.fulfill()
            }
            .store(in: &self.cancellable)
        
        let userId = 101
        store.dispatch(ConsistentStoreParams.Msg.loadUserById(id: userId))
    
        waitForExpectations(timeout: 1)
        
        let expected = [
            ConsistentStoreParams.State(progress: false, loadedUser:  nil), // Initial state
            ConsistentStoreParams.State(progress: true, loadedUser: nil),
            ConsistentStoreParams.State(progress: false, loadedUser: ConsistentStoreParams.State.User(id: userId))
        ]
        XCTAssertEqual(actual, expected)
    }
}
