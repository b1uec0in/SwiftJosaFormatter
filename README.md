# JosaFormatter
String.format을 확장해 받침에 따라 조사(은,는,이,가,을,를 등)를 교정합니다.

***아직 읽는 방법에 대한 규칙을 찾지 못한 부분이 많습니다. 오동작이 발견되거나 좀 더 나은 규칙이 있다면 꼭!! 알려주세요.***

[![CI Status](http://img.shields.io/travis/b1uec0in/SwiftJosaFormatter.svg?style=flat)](https://travis-ci.org/b1uec0in/SwiftJosaFormatter)
[![Version](https://img.shields.io/cocoapods/v/JosaFormatter.svg?style=flat)](http://cocoapods.org/pods/JosaFormatter)
[![License](https://img.shields.io/cocoapods/l/JosaFormatter.svg?style=flat)](http://cocoapods.org/pods/JosaFormatter)
[![Platform](https://img.shields.io/cocoapods/p/JosaFormatter.svg?style=flat)](http://cocoapods.org/pods/JosaFormatter)

## Example

```swift
KoreanUtils.format("%@를 %@으로 변경할까요?", "아이폰", "Galaxy");

아이폰을 Galaxy로 변경할까요?
```

예제 프로그램을 실행하려면, repository를 clone한 후, Example 폴더에서 `pod install` 을 먼저 실행하세요.

## Installation

JosaFormatter는 [CocoaPods](http://cocoapods.org)을 통해 사용할 수 있습니다. 
사용하려는 프로젝트의 Podfile에 아래와 같이 추가하세요:

```ruby
pod "JosaFormatter"
```

### Features
* 앞 글자의 종성(받침) 여부에 따라 조사(은,는,이,가,을,를 등)를 교정합니다.
* 한글 뿐만 아니라 영어, 숫자, 한자, 일본어 등도 처리가 가능합니다.
* 조사 앞에 인용 부호나 괄호가 있어도 동작합니다.
```java
KoreanUtils.format("'%@'는 사용중인 닉네임입니다.", nickName);
```
* Detector를 직접 등록하거나 우선 순위 등을 조정할 수 있습니다. (JongSungDetector 클래스 순서 참고)


### JongSungDetector 기본 우선 순위
* 한글 (HangulJongSungDetector)<br/>
: '홍길동'은
* 영문 대문자 약어 (EnglishCapitalJongSungDetector)<br/>
: 'IBM'이(아이비엠이)
* 일반 영문 (EnglishJongSungDetector)<br/>
: 'Google'을(구글을)
* 영문+숫자 (EnglishNumberJongSungDetector)<br/>
: 'WD40'는(더블유디포티는) - 이렇게 읽는 경우는 드물어 기본으로는 등록되어 있지 않습니다. (예외 처리 참고)
* 영문+10이하 숫자 (EnglishNumberKorStyleJongSungDetector)<br/>
: 'MP3'는(엠피쓰리는), 'WD40'은(더블유디사십은)
* 숫자 (NumberJongSungDetector)<br/>
: '1'과 '2'는(일과 이는)
* 한자 (HanjaJongSungDetector)<br/>
: '6月'은(유월은)
* 일본어 JapaneseJongSungDetector<br/>
: 'あゆみ'는(아유미는)

### 예외 처리
* '영문+숫자'는 경우 10 이하만 영어로 읽도록 되어 있습니다.<br/>
보통 'MP3'는 '엠피쓰리'로 읽지만, 'Office 2000'은 '오피스 이천'으로 읽습니다.<br/>
만약 '영문+숫자'를 항상 영어로 읽도록 하기 위해서는 직접 EnglishNumberJongSungDetector 를 등록해야 합니다.

```swift
var josaFormatter = JosaFormatter()
var text = josaFormatter.format("%@을 구매하시겠습니까?", "Office 2000"));
// Office 2000을 구매하시겠습니까? -> 기본 설정은 '오피스 이천'으로 읽도록 되어 있음.


// EnglishNumberKorStyleJongSungDetector 대신 EnglishNumberJongSungDetector를 등록
josaFormatter.jongSungDetectors = josaFormatter.jongSungDetectors.map {
    $0 is JosaFormatter.EnglishNumberKorStyleJongSungDetector ? JosaFormatter.EnglishNumberJongSungDetector() : $0
}

var text = josaFormatter.format("%@을 구매하시겠습니까?", "Office 2000"));
// Office 2000를 구매하시겠습니까? -> '오피스 투싸우전드'로 읽음

```

* '한글+숫자'인 경우 숫자는 한글로 읽도록 되어 있습니다.<br/>
하지만, 영어를 한글로 쓴 경우 숫자도 영어로 읽어야 해서 오동작하는 경우가 있습니다.
현재는 읽는 규칙을 직접 추가해줘서 영어로 간주하도록 할 수 있습니다.
```swift
KoreanUtils.defaultJosaFormatter.addReadRule("베타", "beta");
var text = KoreanUtils.format("%@을 구매하시겠습니까?", "베가 베타 3"));
// 베가 베타 3를 구매하시겠습니까?
```

### Reference
* 한글 받침에 따라 '을/를' 구분 <br/>
http://gun0912.tistory.com/65

* 한글, 영어 받침 처리 (iOS) <br/>
https://github.com/trilliwon/JNaturalKorean

* 한자를 한글로 변환 <br/>
http://kangwoo.tistory.com/33

* suffix로 영어 단어 찾기 <br/>
http://www.litscape.com/word_tools/ends_with.php
