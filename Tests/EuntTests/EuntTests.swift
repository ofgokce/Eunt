import XCTest
@testable import Eunt

final class EuntTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }
}

struct MainTabBarRoute: Routable, RoutableOwner {
    
    init() {
        self.init(with: [])
    }
    
    init(with routables: [Eunt.Routable]) {
        
    }
    
    func build() -> UIViewController {
        return UIViewController()
    }
}
