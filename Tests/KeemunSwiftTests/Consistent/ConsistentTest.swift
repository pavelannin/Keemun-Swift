import XCTest
import Combine
@testable import Keemun

final class ConsistentTest: XCTestCase {
    private var cancellable: Set<AnyCancellable> = []
    
    func testUpdater1() throws {
        let userId = 101
        let defaultState = ConsistentState(progress: false, loadedUser: nil)
        let msg = ConsistentMsg.loadUserById(id: userId)
        let next = consistentStoreParams().update.run(msg, defaultState)
        XCTAssertEqual(next.state, ConsistentState(progress: true, loadedUser: nil))
        XCTAssertEqual(next.effects, [ConsistentEffect.loadUser(id: userId)])
    }
    
    func testUpdater2() throws {
        let defaultState = ConsistentState(progress: true, loadedUser: nil)
        let user = ConsistentState.User(id: 101)
        let msg = ConsistentMsg.userWasLoaded(user: user)
        let next = consistentStoreParams().update.run(msg, defaultState)
        XCTAssertEqual(next.state, ConsistentState(progress: false, loadedUser: user))
        XCTAssertEqual(next.effects, [])
    }
    
    func testFull() throws {
        let expectation = self.expectation(description: "Waiting for the result to be received")
        let store = Keemun.Store(consistentStoreParams())
        var actual: [ConsistentState] = []
        store.state
            .collect(3)
            .first()
            .sink {
                actual = $0
                expectation.fulfill()
            }
            .store(in: &self.cancellable)
        
        let userId = 101
        store.dispatch(ConsistentMsg.loadUserById(id: userId))
    
        waitForExpectations(timeout: 1)
        
        let expected = [
            ConsistentState(progress: false, loadedUser:  nil), // Initial state
            ConsistentState(progress: true, loadedUser: nil),
            ConsistentState(progress: false, loadedUser: ConsistentState.User(id: userId))
        ]
        XCTAssertEqual(actual, expected)
    }
}
