//
//  JosaFormatter.swift
//  JosaFormatter
//
//  Created by 1100388 on 5/25/17.
//  Copyright © 2017 1100388. All rights reserved.
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
    private var jongSungDetectors = [
    HangulJongSungDetector(),
//    new EnglishCapitalJongSungDetector(),
//    new EnglishJongSungDetector(),
//    //new EnglishNumberJongSungDetector(), // 일반인이 영어+숫자인 경우 항상 숫자를 영어로 읽는 경우는 드물기 때문에 사용하지 않음.
//    new EnglishNumberKorStyleJongSungDetector(),
//    new NumberJongSungDetector(),
//    new HanjaJongSungDetector(),
//    new JapaneseJongSungDetector()
    ]
//
//    // 사용자 추가 읽기 규칙. 주로 한글+숫자인 경우 한글로 쓴 외국어를 영어로 인식하기 위해 필요함.
//    // ex) 아이폰3는 한글뒤의 숫자를 '아이폰삼'이 아니라 '아이폰쓰리'로 읽기 위해서는 '아이폰' 한글을 'iPhone' 영어로 인식해야 한다.
//    // 특히 숫자 0,3,6이 사용될 가능성이 있는 경우에 유용함. (0,3,6은 영어로 발음할 때 종성 유무가 한글과 다르다.
//    // 반대로 '포르쉐911' 처럼 '포르쉐구일일'이나 '포르쉐나인원원'로 읽어도 종성 유무가 동일한 경우는 규칙에 넣을 필요가 없다.
//    private ArrayList<Pair<String, String>> readingRules = new ArrayList<>(Arrays.asList(
//    new Pair<>("아이폰", "iPhone"),
//    new Pair<>("갤럭시", "Galaxy"),
//    new Pair<>("넘버", "number")
//    ));
//    
//    public ArrayList<JongSungDetector> getJongSungDetectors() {
//    return jongSungDetectors;
//    }
//    
//    public void setJongSungDetectors(ArrayList<JongSungDetector> jongSungDetectors) {
//    this.jongSungDetectors = jongSungDetectors;
//    }
//    
//    public String format(String format, Object... args) {
//    return format(Locale.getDefault(), format, args);
//    }
//    
//    public String format(Locale l, String format, Object... args) {
//    ArrayList<Formatter.FormattedString> formattedStrings = Formatter.format(l, format, args);
//    
//    int count = formattedStrings.size();
//    StringBuilder sb = new StringBuilder(formattedStrings.get(0).toString());
//    
//    if (count == 1) {
//    return sb.toString();
//    }
//    
//    for (int i = 1; i < formattedStrings.size(); ++i) {
//    Formatter.FormattedString formattedString = formattedStrings.get(i);
//    
//    String str;
//    
//    if (formattedString.isFixedString()) {
//    str = getJosaModifiedString(formattedStrings.get(i - 1).toString(), formattedString.toString());
//    } else {
//    str = formattedString.toString();
//    }
//    
//    sb.append(str);
//    }
//    
//    return sb.toString();
//    }
//    
    public init() {}
    
    
    public func format(_ format: String, _ arguments: CVarArg...) -> String {
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
                let typeRange = NSMakeRange(indexRange.length + 1, range.length - indexRange.length - 1)
                
                // NSLog("\(range.location),\(range.length) \(indexRange.location),\(indexRange.length) \(typeRange.location),\(typeRange.length)")
                var argIndex = index
                if (indexRange.length > 0) {
                    if let number = Int(format.substring(with: format.index(format.startIndex, offsetBy: indexRange.location)..<format.index(format.startIndex, offsetBy: indexRange.location + indexRange.length - 1))) {
                        argIndex = number - 1
                    }
                }
                
                let singleFormat = "%" + format.substring(with: format.index(format.startIndex, offsetBy: typeRange.location)..<format.index(format.startIndex, offsetBy: typeRange.location + typeRange.length))
                let argString = String(format:singleFormat, arguments[argIndex])
                
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
                    if (CharacterSet.isWhitespace(str.charAt(josaNext))) {
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
            return str.substring(beginIndex:0, endIndex:josaIndex) + replaceStr + str.substring(beginIndex: josaIndex + searchStr!.length)
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
            return str.substring(beginIndex:0, endIndex:josaIndex) + replaceStr + str.substring(beginIndex: josaIndex + searchStr.length)
        }
        
        return str;
    }
    //
    
    public func isEndSkipText(_ str:String, begin:Int, end:Int) -> Bool {
        for i in begin..<end {
            if (!isEndSkipText(str.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    // 조사 앞에 붙는 문자중 무시할 문자들. ex) "(%s)으로"
    public func isEndSkipText(_ ch : Character) -> Bool{
        let skipChars = "\"')]}>";
        
        return skipChars.indexOf(ch) >= 0
    }
    
    public func getReadText(_ str: String ) -> String {
        return str;
//    for (Pair<String, String> readingRule : readingRules) {
//    str = str.replace(readingRule.first, readingRule.second);
//    }
//    
//    int skipCount = 0;
//    
//    int i;
//    for (i = str.length() - 1; i >= 0; --i) {
//    char ch = str.charAt(i);
//    
//    if (!isEndSkipText(ch)) {
//    break;
//    }
//    }
//    
//    return str.substring(0, i + 1);
    }
//
//    public void addReadRule(String originalText, String replaceText) {
//    for (Pair<String, String> readingRule : readingRules) {
//    if (readingRule.first.equals(originalText)) {
//    readingRules.remove(readingRule);
//    break;
//    }
//    }
//    readingRules.add(new Pair<>(originalText, replaceText));
//    }
//    
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
            if let lastChar = str.characters.last {
                return String(lastChar).rangeOfCharacter(from: CharacterSet.hangulFullChars) != nil;
            }
            return false
        }
        
        public override func hasJongSung(_ str:String) -> Bool{
            if let lastChar = str.characters.last {
                return CharUtils.hasHangulJongSung(lastChar);
            }
            return false
        }
    }
    
//    public static class EnglishCapitalJongSungDetector implements JongSungDetector {
//    
//    @Override
//    public boolean canHandle(String str) {
//    char ch = CharUtils.lastChar(str);
//    if (CharUtils.isAlphaUpperCase(ch)) {
//    return true;
//    }
//    
//    return false;
//    }
//    
//    @Override
//    public boolean hasJongSung(String str) {
//    String jongSungChars = "LMNR";
//    char lastChar = CharUtils.lastChar(str);
//    return jongSungChars.indexOf(lastChar) >= 0;
//    }
//    }
//    
//    
//    public static class EnglishJongSungDetector implements JongSungDetector {
//    
//    @Override
//    public boolean canHandle(String str) {
//    char lastChar  = CharUtils.lastChar(str);
//    
//    // q, j 등으로 끝나는 단어는 알려지지 않음.
//    String unknownWordSuffixs = "qj";
//    
//    if (unknownWordSuffixs.indexOf(lastChar) >= 0) {
//    return false;
//    }
//    
//    return CharUtils.isAlpha(lastChar);
//    }
//    
//    @Override
//    public boolean hasJongSung(String str) {
//    char lastChar1 = CharUtils.lastChar(str);
//    
//    // 3자 이상인 경우만 마지막 2자만 suffix로 간주.
//    String suffix = null;
//    if (str.length() >= 3) {
//    char lastChar2 = str.charAt(str.length() - 2);
//    char lastChar3 = str.charAt(str.length() - 3);
//    
//    if (CharUtils.isAlpha(lastChar2) && CharUtils.isAlpha(lastChar3)) {
//    suffix = (String.valueOf(lastChar2) + String.valueOf(lastChar1)).toLowerCase();
//    }
//    }
//    
//    if (suffix != null) {
//    // 마지막 1문자로 오면 항상 종성인 경우
//    String jongSungChars = "blmnp";
//    if (jongSungChars.indexOf(lastChar1) >= 0) {
//    return true;
//    }
//    
//    // 마지막 1문자로 오면 항상 종성이 아닌 경우
//    String notJongSungChars = "afhiorsuvwxyz";
//    if (jongSungChars.indexOf(lastChar1) >= 0) {
//    return false;
//    }
//    
//    // 마지막 2문자로 오면 항상 종성인 경우
//    switch (suffix) {
//    case "le":
//    case "ne":
//    case "me":
//    case "ng":
//    return true;
//    }
//    
//    // 마지막 2문자로 오면 항상 종성이 아닌 경우
//    switch (suffix) {
//    case "lc": // 크
//    case "rc":
//    case "sc":
//    
//    case "ed": // 드
//    case "nd":
//    case "ld":
//    case "rd":
//    
//    case "lk": // 크
//    case "nk":
//    case "sk":
//    case "rk":
//    
//    case "lt": // 트
//    case "nt":
//    case "pt":
//    case "rt":
//    case "st":
//    case "xt":
//    return false;
//    }
//    
//    // 마지막 2문자에 따라 단어별 예외 케이스가 있는 경우
//    switch (suffix) {
//    case "od":
//    return str.endsWith("god") || str.endsWith("good") || str.endsWith("pod");
//    }
//    
//    // 나머지는 마지막 1문자를 보고 종성을 판단 한다.
//    String jongSungExtraChars = "cdkpqt";
//    if (jongSungExtraChars.indexOf(lastChar1) >= 0) {
//    return true;
//    }
//    } else {
//    // 1자, 2자는 약자로 간주하고 알파벳 그대로 읽음. (엘엠엔알)만 종성이 있음.
//    String jongSungChars = "lmnr";
//    if (jongSungChars.indexOf(lastChar1) >= 0) {
//    return true;
//    }
//    }
//    return false;
//    }
//    }
//    
//    // 영문+숫자를 미국식으로 읽기 ex) MP3, iPhone4, iOS8.3 (iOS eight point three), Office2003 (Office two thousand three)
//    // 일반적으로 영문+숫자라도 11 이상은 그냥 한글로 읽는 경우가 많아서 적합하지 않을 수 있음.
//    public static class EnglishNumberJongSungDetector implements JongSungDetector {
//    public static ParseResult parse(String str) {
//    ParseResult parseResult = new ParseResult();
//    int i;
//    boolean isSpaceFound = false;
//    int numberPartBeiginIndex = 0;
//    boolean isNumberCompleted = false;
//    // 뒤에서부터 숫자, 영어 순서로 찾는다.
//    for (i = str.length() - 1; i >= 0; --i) {
//    char ch = str.charAt(i);
//    
//    if (!isNumberCompleted && !isSpaceFound && CharUtils.isNumber(ch)) {
//    parseResult.isNumberFound = true;
//    numberPartBeiginIndex = i;
//    continue;
//    }
//    
//    if (ch == ',') {
//    continue;
//    }
//    
//    if (!isNumberCompleted && parseResult.isNumberFound && !parseResult.isFloat && ch == '.') {
//    parseResult.isFloat = true;
//    continue;
//    }
//    
//    // 공백은 숫자가 찾아진 이후 한번만 허용
//    if (!isNumberCompleted && parseResult.isNumberFound && !isSpaceFound && ch == ' ') {
//    isSpaceFound = true;
//    isNumberCompleted = true;
//    continue;
//    }
//    
//    // - 는 음수나 dash 용도로 사용될 수 있음.
//    if (!isNumberCompleted && parseResult.isNumberFound && !isSpaceFound && ch == '-') {
//    isNumberCompleted = true;
//    continue;
//    }
//    
//    // 영어는 숫자가 찾아진 이후에만 허용
//    if (parseResult.isNumberFound && CharUtils.isAlpha(ch)) {
//    parseResult.isEnglishFound = true;
//    isNumberCompleted = true;
//    break;
//    }
//    
//    break;
//    }
//    
//    if (parseResult.isNumberFound) {
//    parseResult.numberPart = str.substring(numberPartBeiginIndex);
//    parseResult.prefixPart = str.substring(0, numberPartBeiginIndex);
//    
//    try {
//    parseResult.number = Double.parseDouble(parseResult.numberPart);
//    } catch (Exception ignore) {
//    }
//    }
//    
//    return parseResult;
//    }
//    
//    @Override
//    public boolean canHandle(String str) {
//    EnglishNumberJongSungDetector.ParseResult parseResult = EnglishNumberJongSungDetector.parse(str);
//    
//    return parseResult.isNumberFound && parseResult.isEnglishFound;
//    
//    }
//    
//    @Override
//    public boolean hasJongSung(String str) {
//    EnglishNumberJongSungDetector.ParseResult parseResult = EnglishNumberJongSungDetector.parse(str);
//    
//    if (!parseResult.isFloat) {
//    long number = (long) (parseResult.number);
//    
//    if (number == 0) {
//    return false;
//    }
//    
//    // 두자리 예외 처리
//    int twoDigit = (int) (number % 100);
//    switch (twoDigit) {
//    case 10:
//    case 13:
//    case 14:
//    case 16:
//    return true;
//    }
//    
//    // million 이상 예외 처리
//    // 100 : hundred (x)
//    // 1000 : thousand (x)
//    // 1000000... : million, billion, trillion (o)
//    if (number % 100000 == 0) {
//    return true;
//    }
//    }
//    
//    // 마지막 한자리 (소수 포함)
//    int oneDigit = CharUtils.lastChar(parseResult.numberPart) - '0';
//    
//    switch (oneDigit) {
//    case 1:
//    case 7:
//    case 8:
//    case 9:
//    return true;
//    }
//    
//    return false;
//    }
//    
//    public static class ParseResult {
//    public boolean isNumberFound;
//    
//    // valid only if isNumberFound
//    public boolean isEnglishFound;
//    public double number;
//    public boolean isFloat;
//    public String prefixPart;
//    public String numberPart;
//    }
//    }
//    
//    // 영문+숫자 10이하만 영어로 읽기 ex) MP3, iPhone4
//    // 다른 경우에는 숫자를 한글로 읽기 위해서는 EnglishNumberJongSungDetector 와 같이 사용하면 안된다.
//    public static class EnglishNumberKorStyleJongSungDetector implements JongSungDetector {
//    
//    @Override
//    public boolean canHandle(String str) {
//    EnglishNumberJongSungDetector.ParseResult parseResult = EnglishNumberJongSungDetector.parse(str);
//    
//    return parseResult.isNumberFound && parseResult.isEnglishFound && !parseResult.isFloat && parseResult.number <= 10;
//    
//    }
//    
//    @Override
//    public boolean hasJongSung(String str) {
//    EnglishNumberJongSungDetector.ParseResult parseResult = EnglishNumberJongSungDetector.parse(str);
//    int number = (int) (parseResult.number);
//    switch (number) {
//    case 1:
//    case 7:
//    case 8:
//    case 9:
//    case 10:
//    return true;
//    }
//    
//    return false;
//    }
//    }
//    
//    // 숫자를 한국식으로 읽기
//    public static class NumberJongSungDetector implements JongSungDetector {
//    @Override
//    public boolean canHandle(String str) {
//    EnglishNumberJongSungDetector.ParseResult parseResult = EnglishNumberJongSungDetector.parse(str);
//    
//    return parseResult.isNumberFound;
//    
//    }
//    
//    @Override
//    public boolean hasJongSung(String str) {
//    EnglishNumberJongSungDetector.ParseResult parseResult = EnglishNumberJongSungDetector.parse(str);
//    
//    if (!parseResult.isFloat) {
//    long number = (long) (parseResult.number);
//    // 조 예외 처리 : 조(받침 없음), 십, 백, 천, 만, 억, 경, 현
//    if (number % 1000000000000L == 0) {
//    return false;
//    }
//}
//
//// 마지막 한자리 (소수 포함)
//int oneDigit = CharUtils.lastChar(parseResult.numberPart) - '0';
//switch (oneDigit) {
//case 0:
//case 1:
//case 3:
//case 6:
//case 7:
//case 8:
//    return true;
//}
//
//return false;
//}
//}
//
//
//// 한자는 한글 코드로 변경해서 판단
//public static class HanjaJongSungDetector implements JongSungDetector {
//    
//    @Override
//    public boolean canHandle(String str) {
//        return HanjaMap.canHandle(CharUtils.lastChar(str));
//    }
//    
//    @Override
//    public boolean hasJongSung(String str) {
//        char hangulChar = HanjaMap.toHangul(CharUtils.lastChar(str));
//        return CharUtils.hasHangulJongSung(hangulChar);
//    }
//}
//
//// 일본어
//public static class JapaneseJongSungDetector implements JongSungDetector {
//    
//    @Override
//    public boolean canHandle(String str) {
//        return CharUtils.isJapanese(CharUtils.lastChar(str));
//    }
//    
//    @Override
//    public boolean hasJongSung(String str) {
//        char lastChar = CharUtils.lastChar(str);
//        
//        return lastChar == 0x30f3 || lastChar == 0x3093;
//    }
//}


}
