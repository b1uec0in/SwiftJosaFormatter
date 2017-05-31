import UIKit
import XCTest
import JosaFormatter

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")

        let formatter = JosaFormatter()
        
        XCTAssertEqual("사람을", formatter.format("%@를", "사람"))
        XCTAssertEqual("갤럭시를 아이폰으로", formatter.format("%1$@을 %2$@으로", "갤럭시", "아이폰"));
        XCTAssertEqual("아이폰을 갤럭시로", formatter.format("%2$@을 %1$@으로", "갤럭시", "아이폰"));
        
        
        
        var text = String(format: "%2$@ %1$@", "1", "2");
        NSLog(text);
        
        text = formatter.format("%2$@ %1$@", "1", "2")
        NSLog(text);
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
