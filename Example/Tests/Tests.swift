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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testExample() {
        XCTAssertEqual("(폰)을", KoreanUtils.format("(%@)를", "폰"))
       
        XCTAssertEqual("OS10은 이미 사용중입니다.", KoreanUtils.format("%@은 이미 사용중입니다.", "OS10"))
        
        // HangulJongSungDetector
        XCTAssertEqual("삼을", KoreanUtils.format("%@을", "삼"))
        XCTAssertEqual("삼을", KoreanUtils.format("%@를", "삼"))
        XCTAssertEqual("사를", KoreanUtils.format("%@을", "사"))
        XCTAssertEqual("사를", KoreanUtils.format("%@를", "사"))
        
        // EnglishCapitalJongSungDetector
        XCTAssertEqual("FBI는 이미 사용중입니다.", KoreanUtils.format("%@는 이미 사용중입니다.", "FBI"))
        XCTAssertEqual("FBI는 이미 사용중입니다.", KoreanUtils.format("%@은 이미 사용중입니다.", "FBI"))
        
        XCTAssertEqual("IBM은 이미 사용중입니다.", KoreanUtils.format("%@는 이미 사용중입니다.", "IBM"))
        XCTAssertEqual("IBM은 이미 사용중입니다.", KoreanUtils.format("%@은 이미 사용중입니다.", "IBM"))
        
        // EnglishJongSungDetector
        XCTAssertEqual("gradle은", KoreanUtils.format("%@는", "gradle"))
        XCTAssertEqual("glide는", KoreanUtils.format("%@는", "glide"))
        XCTAssertEqual("first는", KoreanUtils.format("%@는", "first"))
        XCTAssertEqual("unit은", KoreanUtils.format("%@는", "unit"))
        XCTAssertEqual("p는", KoreanUtils.format("%@는", "p"))
        XCTAssertEqual("app은", KoreanUtils.format("%@는", "app"))
        XCTAssertEqual("method는", KoreanUtils.format("%@는", "method"))
        
        
        // EnglishNumberKorStyleJongSungDetector
        XCTAssertEqual("MP3는 이미 사용중입니다.", KoreanUtils.format("%@는 이미 사용중입니다.", "MP3"))
        XCTAssertEqual("MP3는 이미 사용중입니다.", KoreanUtils.format("%@은 이미 사용중입니다.", "MP3"))
        
        XCTAssertEqual("OS10은 이미 사용중입니다.", KoreanUtils.format("%@은 이미 사용중입니다.", "OS10"))
        XCTAssertEqual("Office2000은 이미 사용중입니다.", KoreanUtils.format("%@은 이미 사용중입니다.", "Office2000"))
        XCTAssertEqual("Office2010은 이미 사용중입니다.", KoreanUtils.format("%@는 이미 사용중입니다.", "Office2010"))
        XCTAssertEqual("WD-40은 이미 사용중입니다.", KoreanUtils.format("%@는 이미 사용중입니다.", "WD-40"))
        
        XCTAssertEqual("iOS8.3은 이미 사용중입니다.", KoreanUtils.format("%@는 이미 사용중입니다.", "iOS8.3"))
        XCTAssertEqual("GS25로 목적지를 설정하시겠습니까?", KoreanUtils.format("%@으로 목적지를 설정하시겠습니까?", "GS25"))
        
        // NumberJongSungDetector
        XCTAssertEqual("3과 4를 비교", KoreanUtils.format("%@와 %@를 비교", "3", "4"))
        XCTAssertEqual("112와 4.0을 비교", KoreanUtils.format("%@와 %@를 비교", "112", "4.0"))
        
        
        // HanjaJongSungDetector
        XCTAssertEqual("6月은", KoreanUtils.format("%@는", "6月"))
        XCTAssertEqual("大韓民國은", KoreanUtils.format("%@는", "大韓民國"))
        
        // JapaneseJongSungDetector
        XCTAssertEqual("たくあん은", KoreanUtils.format("%@는", "たくあん")) // 타쿠앙
        XCTAssertEqual("あゆみ는", KoreanUtils.format("%@은", "あゆみ")) // 아유미
        XCTAssertEqual("マリゾン은", KoreanUtils.format("%@는", "マリゾン")) // 마리존
        
        // getReadText, skipEndText
        XCTAssertEqual("(폰)을", KoreanUtils.format("%@를", "(폰)"))
        XCTAssertEqual("(폰)을", KoreanUtils.format("(%@)를", "폰"))
        
        XCTAssertEqual("갤럭시를 아이폰으로", KoreanUtils.format("%1$@을 %2$@으로", "갤럭시", "아이폰"))
        XCTAssertEqual("iPhone을 Galaxy로", KoreanUtils.format("%2$@을 %1$@으로", "Galaxy", "iPhone"))
        XCTAssertEqual("아이폰을 Galaxy로 변경할까요?", KoreanUtils.format("%@를 %@으로 변경할까요?", "아이폰", "Galaxy"))
        
        // 판단 불가
        XCTAssertEqual("???을(를) 찾을 수 없습니다.", KoreanUtils.format("%@를 찾을 수 없습니다.", "???"))
        
        // ignore
        XCTAssertEqual("서울에서", KoreanUtils.format("%@에서", "서울"))
        
        // 기타
        XCTAssertEqual("SK에서는 幸福과 覇氣를 기억하세요.", KoreanUtils.format("%@에서는 %@와 %@를 기억하세요.", "SK", "幸福", "覇氣"))
        
        // 외국어 처리 : 외국어 뒤 숫자를 영어로 읽는 경우.
        XCTAssertEqual("아이폰3를 갤럭시6로", KoreanUtils.format("%2$@을 %1$@으로", "갤럭시6", "아이폰3"))
        
        // 사용자 규칙 추가
        KoreanUtils.defaultJosaFormatter.addReadRule("베타", "beta")
        XCTAssertEqual("베타3를", KoreanUtils.format("%@을", "베타3"))

    }
    
    func testEnglishJongSungDetector()  {
        
        // 받침 있는 경우
        let jongSungSample :[String] = [
            "apple",
            "god",
            "game",
            "gone",
            ];
        
        // 받침 없는 경우
        let notJongSungSample:[String] = [
            "risk",
            "tank",
            "text",
            "wood",
            ];
        
        
        for str in jongSungSample {
            XCTAssertEqual(str + "은", KoreanUtils.format("%@는", str))
        }
        for str in notJongSungSample {
            XCTAssertEqual(str + "는", KoreanUtils.format("%@은", str))
        }
    }

    func testEnglishNumberJongSungDetector() {
        // 영문+숫자인 경우 항상 숫자를 영어로 읽도록 함.
        
        let josaFormatter = JosaFormatter()
        
        josaFormatter.jongSungDetectors = josaFormatter.jongSungDetectors.map {
            $0 is JosaFormatter.EnglishNumberKorStyleJongSungDetector ? JosaFormatter.EnglishNumberJongSungDetector() : $0
        }
        
        XCTAssertEqual("MP3는 이미 사용중입니다.", josaFormatter.format("%@는 이미 사용중입니다.", "MP3"));
        XCTAssertEqual("MP3는 이미 사용중입니다.", josaFormatter.format("%@은 이미 사용중입니다.", "MP3"));
        
        XCTAssertEqual("OS10은 이미 사용중입니다.", josaFormatter.format("%@은 이미 사용중입니다.", "OS10"));
        XCTAssertEqual("Office2000는 이미 사용중입니다.", josaFormatter.format("%@은 이미 사용중입니다.", "Office2000"));
        XCTAssertEqual("Office2010은 이미 사용중입니다.", josaFormatter.format("%@는 이미 사용중입니다.", "Office2010"));
        XCTAssertEqual("WD-40는 이미 사용중입니다.", josaFormatter.format("%@는 이미 사용중입니다.", "WD-40"));
        
        XCTAssertEqual("iOS8.3는 이미 사용중입니다.", josaFormatter.format("%@는 이미 사용중입니다.", "iOS8.3"));
    }
}
