//
//  JosaFormatter.swift
//  JosaFormatter
//
//  Created by Bae Yong-Ju on 2017-05-26.
//
//

import Foundation

open class JosaFormatter {
    
    // 조사들을 종성이 있을 때와 없을 때 순서로 나열.
    static var josaPairs = [
        "은":"는",
        "이":"가",
        "을":"를",
        "과":"와",
        "으로":"로"
    ]
    
    
    // 종성(받침) 검사 필터. 순서대로 동작함.
    public var jongSungDetectors = [
        HangulJongSungDetector(),
        EnglishCapitalJongSungDetector(),
        EnglishJongSungDetector(),
        //new EnglishNumberJongSungDetector(), // 일반인이 영어+숫자인 경우 항상 숫자를 영어로 읽는 경우는 드물기 때문에 사용하지 않음.
        EnglishNumberKorStyleJongSungDetector(),
        NumberJongSungDetector(),
        HanjaJongSungDetector(),
        JapaneseJongSungDetector(),
        ]
    
    // 사용자 추가 읽기 규칙. 주로 한글+숫자인 경우 한글로 쓴 외국어를 영어로 인식하기 위해 필요함.
    // ex) 아이폰3는 한글뒤의 숫자를 '아이폰삼'이 아니라 '아이폰쓰리'로 읽기 위해서는 '아이폰' 한글을 'iPhone' 영어로 인식해야 한다.
    // 특히 숫자 0,3,6이 사용될 가능성이 있는 경우에 유용함. (0,3,6은 영어로 발음할 때 종성 유무가 한글과 다르다.
    // 반대로 '포르쉐911' 처럼 '포르쉐구일일'이나 '포르쉐나인원원'로 읽어도 종성 유무가 동일한 경우는 규칙에 넣을 필요가 없다.
    private var readingRules = [
        "아이폰" : "iPhone",
        "갤럭시" : "Galaxy",
        "넘버": "number"
    ]
    
    public init() {}
    
    public func format(_ format: String, _ arguments: CVarArg...) -> String {
        return self.format(format, arguments)
    }
    
    public func format(_ format: String, _ arguments: [CVarArg]) -> String {
        return self.format(format, locale: Locale.current, arguments)
    }
    
    public func format(_ format: String, locale: Locale?, _ arguments: CVarArg...) -> String {
        return self.format(format, locale: locale, arguments)
    }
    
    public func format(_ format: String, locale: Locale?, _ arguments: [CVarArg]) -> String {
        if arguments.count > 0 {
            let pattern = "%(\\d+\\$)?([-#+ 0,(\\<]*)?(\\d+)?(\\.\\d+)?([tT])?([a-zA-Z%@])"
            guard let regex = try? NSRegularExpression(pattern:pattern) else {
                return format
            }
            
            let nsFormat : NSString = format as NSString
            let results = regex.matches(in: format, options: [.reportCompletion], range: NSMakeRange(0, nsFormat.length))
            
            
            var resultString = format.substring(to: format.index(format.startIndex, offsetBy: results[0].range.location))
            
            
            for index in 0..<results.count {
                let result = results[index]
                
                let range = result.rangeAt(0)
                let indexRange = result.rangeAt(1)
                let typeRange = NSMakeRange(range.location + indexRange.length + 1, range.length - indexRange.length - 1)
                
                var argIndex = index
                if (indexRange.length > 0) {
                    if let number = Int(format.substring(with: format.index(format.startIndex, offsetBy: indexRange.location)..<format.index(format.startIndex, offsetBy: indexRange.location + indexRange.length - 1))) {
                        argIndex = number - 1
                    }
                }
                
                let singleFormat = "%" + format.substring(with: format.index(format.startIndex, offsetBy: typeRange.location)..<format.index(format.startIndex, offsetBy: typeRange.location + typeRange.length))
                let argString = String(format:singleFormat, locale: locale, arguments[argIndex])
                
                var nextString = ""
                if index < results.count - 1 {
                    nextString = format.substring(with: format.index(format.startIndex, offsetBy: range.location + range.length)..<format.index(format.startIndex, offsetBy: results[index+1].range.location))
                } else {
                    nextString = format.substring(from: format.index(format.startIndex, offsetBy: range.location + range.length))
                }
                
                
                resultString += join(argString, nextString)
                
            }
            
            return resultString
            
        } else {
            return format
        }
    }
    
    
    
    func indexOfJosa(_ str:String, josa:String) -> Int {
        var index : Int;
        var searchFromIndex = 0;
        let strLength = str.length;
        let josaLength = josa.length;
        repeat {
            index = str.indexOf(josa, fromIndex: searchFromIndex);
            
            if index >= 0 {
                let josaNext = index + josaLength;
                
                // 조사로 끝나거나 뒤에 공백이 있어야 함.
                if (josaNext < strLength) {
                    if (CharacterSet.whitespacesAndNewlines.contains(str.unicodeScalarAt(josaNext))) {
                        return index;
                    }
                } else {
                    return index;
                }
            } else {
                return -1;
            }
            searchFromIndex = index + josaLength;
        } while(searchFromIndex < strLength);
        
        return -1;
    }
    
    
    func getJosaModifiedString(_ previous:String, str:String) -> String {
        
        if (previous.length == 0) {
            return str
        }
        
        var matchedJosaPair:(key:String, value:String)?
        var josaIndex = -1
        
        var searchStr:String?
        for josaPair in JosaFormatter.josaPairs {
            let firstIndex = indexOfJosa(str, josa: josaPair.key);
            let secondIndex = indexOfJosa(str, josa: josaPair.value);
            
            if (firstIndex >= 0 && secondIndex >= 0) {
                if (firstIndex < secondIndex) {
                    josaIndex = firstIndex;
                    searchStr = josaPair.key;
                } else {
                    josaIndex = secondIndex;
                    searchStr = josaPair.value;
                }
            } else if (firstIndex >= 0) {
                josaIndex = firstIndex;
                searchStr = josaPair.key;
            } else if (secondIndex >= 0) {
                josaIndex = secondIndex;
                searchStr = josaPair.value;
            }
            
            if (josaIndex >= 0 && isEndSkipText(str, begin:0, end:josaIndex)) {
                matchedJosaPair = josaPair;
                break;
            }
        }
        
        if (matchedJosaPair != nil) {
            
            let readText = getReadText(previous);
            
            for jongSungDetector in jongSungDetectors {
                if (jongSungDetector.canHandle(readText)) {
                    return replaceStringByJongSung(str, josaPair:matchedJosaPair!, hasJongSung:jongSungDetector.hasJongSung(readText));
                }
            }
            
            // 없으면 괄호 표현식을 사용한다. ex) "???을(를) 찾을 수 없습니다."
            
            let replaceStr = "\(matchedJosaPair!.key)(\(matchedJosaPair!.value))"
            return str.substring(0, josaIndex) + replaceStr + str.substring(josaIndex + searchStr!.length)
        }
        
        return str
    }
    
    public func join(_ str1: String, _ str2: String) -> String {
        return str1 + getJosaModifiedString(str1, str:str2);
    }
    
    
    public func replaceStringByJongSung(_ str:String, josaPair: (key:String, value:String), hasJongSung:Bool) -> String {
        // 잘못된 것을 찾아야 하므로 반대로 찾는다. 종성이 있으면 종성이 없을 때 사용하는 조사가 사용 되었는지 찾는다.
        let searchStr = hasJongSung ? josaPair.value : josaPair.key;
        let replaceStr = hasJongSung ? josaPair.key : josaPair.value;
        let josaIndex = str.indexOf(searchStr)
        
        if josaIndex >= 0 && isEndSkipText(str, begin:0, end:josaIndex) {
            return str.substring(0, josaIndex) + replaceStr + str.substring(josaIndex + searchStr.length)
        }
        
        return str;
    }
    //
    
    public func isEndSkipText(_ str:String, begin:Int, end:Int) -> Bool {
        for i in begin..<end {
            if (!isEndSkipText(str.unicodeScalarAt(i))) {
                return false;
            }
        }
        return true;
    }
    
    // 조사 앞에 붙는 문자중 무시할 문자들. ex) "(%s)으로"
    public func isEndSkipText(_ ch : UnicodeScalar) -> Bool{
        let skipChars = CharacterSet(charactersIn:"\"')]}>");
        
        return skipChars.contains(ch)
    }
    
    public func getReadText(_ str: String ) -> String {
        var readText = str
        for readingRule in readingRules {
            readText = readText.replacingOccurrences(of: readingRule.key, with: readingRule.value)
        }
        
        var index = readText.length - 1;
        for i in (0..<readText.length).reversed() {
            index = i
            let ch = readText.unicodeScalarAt(i)
            
            if !isEndSkipText(ch) {
                break;
            }
        }
        
        return readText.substring(0, index + 1);
    }
    
    public func addReadRule(_ originalText:String, _ replaceText: String) {
        readingRules[originalText] = replaceText
    }
    
    public class JongSungDetector {
        func canHandle(_ str:String ) ->Bool {
            return false
        }
        
        func hasJongSung(_ str :String ) -> Bool {
            return false
        }
    }
    
    
    public class HangulJongSungDetector : JongSungDetector {
        
        public override func canHandle(_ str : String) -> Bool{
            if let lastChar = str.unicodeScalars.last {
                return CharacterSet.hangulSyllables.contains(lastChar);
            }
            return false
        }
        
        public override func hasJongSung(_ str:String) -> Bool{
            let lastChar = str.unicodeScalars.last!
            return CharUtils.hasHangulJongSung(lastChar);
        }
    }
    
    public class EnglishCapitalJongSungDetector : JongSungDetector {
        
        public override func canHandle(_ str : String) -> Bool{
            if let lastChar = str.characters.last {
                if (String(lastChar).rangeOfCharacter(from: .uppercaseLetters) != nil) {
                    return true
                }
            }
            
            return false;
        }
        
        public override func hasJongSung(_ str:String) -> Bool{
            if let lastChar = str.characters.last {
                let jongSungChars = "LMNR"
                return jongSungChars.indexOf(lastChar) >= 0
            }
            return false
        }
    }
    
    
    public class EnglishJongSungDetector : JongSungDetector {
        
        
        public override func canHandle(_ str : String) -> Bool{
            if let lastChar = str.unicodeScalars.last {
                
                // q, j 등으로 끝나는 단어는 알려지지 않음.
                let unknownWordSuffixs = CharacterSet(charactersIn:"qj");
                
                if unknownWordSuffixs.contains(lastChar) {
                    return false;
                }
                
                return CharacterSet.asciiAlphas.contains(lastChar)
            }
            return false
        }
        
        
        public override func hasJongSung(_ str:String) -> Bool{
            let lastChar1 = str.characters.last!
            
            // 3자 이상인 경우만 마지막 2자만 suffix로 간주.
            var suffix:String? = nil;
            if str.length >= 3 {
                let lastChar2 = str.unicodeScalarAt(str.length - 2);
                let lastChar3 = str.unicodeScalarAt(str.length - 3);
                
                if (CharacterSet.asciiAlphas.contains(lastChar2) && CharacterSet.asciiAlphas.contains(lastChar3)) {
                    suffix = (String(lastChar2) + String(lastChar1)).lowercased();
                }
            }
            
            if let suffix = suffix {
                // 마지막 1문자로 오면 항상 종성인 경우
                let jongSungChars = "blmnp";
                if jongSungChars.indexOf(lastChar1) >= 0 {
                    return true;
                }
                
                // 마지막 1문자로 오면 항상 종성이 아닌 경우
                let notJongSungChars = "afhiorsuvwxyz";
                if notJongSungChars.indexOf(lastChar1) >= 0 {
                    return false;
                }
                
                // 마지막 2문자로 오면 항상 종성인 경우
                switch (suffix) {
                case "le",
                     "ne",
                     "me",
                     "ng":
                    return true
                default: break
                }
                
                // 마지막 2문자로 오면 항상 종성이 아닌 경우
                switch (suffix) {
                case "lc", // 크
                "rc",
                "sc",
                
                "ed", // 드
                "nd",
                "ld",
                "rd",
                
                "lk", // 크
                "nk",
                "sk",
                "rk",
                
                "lt", // 트
                "nt",
                "pt",
                "rt",
                "st",
                "xt":
                    return false
                default: break
                }
                
                // 마지막 2문자에 따라 단어별 예외 케이스가 있는 경우
                switch (suffix) {
                case "od":
                    return str.hasSuffix("god") || str.hasSuffix("good") || str.hasSuffix("pod");
                default: break
                }
                
                // 나머지는 마지막 1문자를 보고 종성을 판단 한다.
                let jongSungExtraChars = "cdkpqt";
                if jongSungExtraChars.indexOf(lastChar1) >= 0 {
                    return true;
                }
            } else {
                // 1자, 2자는 약자로 간주하고 알파벳 그대로 읽음. (엘엠엔알)만 종성이 있음.
                let jongSungChars = "lmnr";
                if jongSungChars.indexOf(lastChar1) >= 0 {
                    return true;
                }
            }
            return false;
        }
    }
    
    // 영문+숫자를 미국식으로 읽기 ex) MP3, iPhone4, iOS8.3 (iOS eight point three), Office2003 (Office two thousand three)
    // 일반적으로 영문+숫자라도 11 이상은 그냥 한글로 읽는 경우가 많아서 적합하지 않을 수 있음.
    public class EnglishNumberJongSungDetector : JongSungDetector {
 
        
        public override init() {
        }
        public static func parse(_ str:String) -> ParseResult{
            let parseResult = ParseResult()
            var isSpaceFound = false
            var numberPartBeiginIndex = 0
            var isNumberCompleted = false
            // 뒤에서부터 숫자, 영어 순서로 찾는다.
            for i in (0..<str.length).reversed() {
                let ch = str.unicodeScalarAt(i)
                
                if (!isNumberCompleted && !isSpaceFound && CharacterSet.asciiNumbers.contains(ch)) {
                    parseResult.isNumberFound = true;
                    numberPartBeiginIndex = i;
                    continue;
                }
                
                if ch == "," {
                    continue
                }
                
                if !isNumberCompleted && parseResult.isNumberFound && !parseResult.isFloat && ch == "." {
                    parseResult.isFloat = true
                    continue
                }
                
                // 공백은 숫자가 찾아진 이후 한번만 허용
                if !isNumberCompleted && parseResult.isNumberFound && !isSpaceFound && ch == " " {
                    isSpaceFound = true
                    isNumberCompleted = true
                    continue
                }
                
                // - 는 음수나 dash 용도로 사용될 수 있음.
                if !isNumberCompleted && parseResult.isNumberFound && !isSpaceFound && ch == "-" {
                    isNumberCompleted = true
                    continue
                }
                
                // 영어는 숫자가 찾아진 이후에만 허용
                if parseResult.isNumberFound && CharacterSet.asciiAlphas.contains(ch) {
                    parseResult.isEnglishFound = true
                    isNumberCompleted = true
                    break
                }
                
                break
            }
            
            if parseResult.isNumberFound {
                parseResult.numberPart = str.substring(numberPartBeiginIndex)
                parseResult.prefixPart = str.substring(0, numberPartBeiginIndex)
                
                if let number = Double(parseResult.numberPart) {
                    parseResult.number = number
                }
            }
            
            return parseResult;
        }
        
        
        public override func canHandle(_ str : String) -> Bool{
            let parseResult = EnglishNumberJongSungDetector.parse(str)
            
            return parseResult.isNumberFound && parseResult.isEnglishFound
            
        }
        
        
        public override func hasJongSung(_ str:String) -> Bool{
            let parseResult = EnglishNumberJongSungDetector.parse(str)
            
            if !parseResult.isFloat {
                let number = Int(parseResult.number)
                
                if number == 0 {
                    return false
                }
                
                // 두자리 예외 처리
                let twoDigit = (Int) (number % 100);
                switch (twoDigit) {
                case 10,
                     13,
                     14,
                     16:
                    return true
                default:break
                }
                
                // million 이상 예외 처리
                // 100 : hundred (x)
                // 1000 : thousand (x)
                // 1000000... : million, billion, trillion (o)
                if (number % 100000 == 0) {
                    return true;
                }
            }
            
            // 마지막 한자리 (소수 포함)
            if let oneDigit = Int(String(parseResult.numberPart.characters.last!)) {
                
                switch (oneDigit) {
                case 1,
                     7,
                     8,
                     9:
                    return true
                default: break
                }
            }
            
            return false
        }
        
        public class ParseResult {
            public var isNumberFound:Bool
            
            // valid only if isNumberFound
            public var isEnglishFound:Bool
            public var number:Double
            public var isFloat:Bool
            public var prefixPart:String
            public var numberPart:String
            public init() {
                isNumberFound = false
                isEnglishFound = false
                number = 0
                isFloat = false
                prefixPart = ""
                numberPart = ""
            }
        }
    }
    
    // 영문+숫자 10이하만 영어로 읽기 ex) MP3, iPhone4
    // 다른 경우에는 숫자를 한글로 읽기 위해서는 EnglishNumberJongSungDetector 와 같이 사용하면 안된다.
    public class EnglishNumberKorStyleJongSungDetector : JongSungDetector {
        
        
        public override func canHandle(_ str : String) -> Bool{
            let parseResult = EnglishNumberJongSungDetector.parse(str);
            
            return parseResult.isNumberFound && parseResult.isEnglishFound && !parseResult.isFloat && parseResult.number <= 10
            
        }
        
        
        public override func hasJongSung(_ str:String) -> Bool{
            let parseResult = EnglishNumberJongSungDetector.parse(str);
            let number = Int64(parseResult.number)
            switch (number) {
            case 1,
                 7,
                 8,
                 9,
                 10:
                return true
            default:break
            }
            
            return false
        }
    }
    
    // 숫자를 한국식으로 읽기
    public class NumberJongSungDetector : JongSungDetector {
        
        public override func canHandle(_ str : String) -> Bool{
            let parseResult = EnglishNumberJongSungDetector.parse(str);
            
            return parseResult.isNumberFound;
            
        }
        
        
        public override func hasJongSung(_ str:String) -> Bool{
            let parseResult = EnglishNumberJongSungDetector.parse(str);
            
            if (!parseResult.isFloat) {
                let number = Int64(parseResult.number)
                // 조 예외 처리 : 조(받침 없음), 십, 백, 천, 만, 억, 경, 현
                if (number % 1000000000000) == 0 {
                    return false
                }
            }
            
            // 마지막 한자리 (소수 포함)
            if let oneDigit = Int(String(parseResult.numberPart.characters.last!)) {
                switch (oneDigit) {
                case 0,
                     1,
                     3,
                     6,
                     7,
                     8:
                    return true
                default:break
                }
            }
            
            return false;
        }
    }
    
    
    // 한자는 한글 코드로 변경해서 판단
    public class HanjaJongSungDetector : JongSungDetector {
        public override func canHandle(_ str : String) -> Bool{
            if let lastChar = str.unicodeScalars.last {
                return HanjaMap.canHandle(lastChar);
            }
            return false;
        }
        
        
        public override func hasJongSung(_ str:String) -> Bool{
            let lastChar = str.unicodeScalars.last!
            let hangulChar = HanjaMap.toHangul(lastChar);
            return CharUtils.hasHangulJongSung(hangulChar);
        }
    }
    
    // 일본어
    public class JapaneseJongSungDetector : JongSungDetector {
        
        public override func canHandle(_ str : String) -> Bool{
            if let lastChar = str.unicodeScalars.last {
                return CharacterSet.japaneseCharacters.contains(lastChar)
            }
            return false;
        }
        
        
        public override func hasJongSung(_ str:String) -> Bool{
            let lastChar = str.characters.last!
            
            // ん, ン 로 끝나면 받침이 있는 것으로 간주
            return lastChar == "ん" || lastChar == "ン";
        }
    }
}
