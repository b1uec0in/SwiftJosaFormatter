#
# Be sure to run `pod lib lint JosaFormatter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JosaFormatter'
  s.version          = '1.6.0'
  s.summary          = '받침에 따라 조사(은,는,이,가,을,를 등)를 교정할 수 있는 String.format과 유사한 함수를 제공합니다.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
앞 글자의 종성(받침) 여부에 따라 조사(은,는,이,가,을,를 등)를 교정합니다.
한글 뿐만 아니라 영어, 숫자, 한자, 일본어 등도 처리가 가능합니다.
조사 앞에 인용 부호나 괄호가 있어도 동작합니다.
KoreanUtils.format("'%@'는 사용중인 닉네임 입니다.", nickName)
Detector를 직접 등록하거나 우선 순위 등을 조정할 수 있습니다.
                       DESC

  s.homepage         = 'https://github.com/b1uec0in/SwiftJosaFormatter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'b1uec0in' => 'b1uec0in@naver.com' }
  s.source           = { :git => 'https://github.com/b1uec0in/SwiftJosaFormatter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JosaFormatter/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JosaFormatter' => ['JosaFormatter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
