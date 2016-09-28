Pod::Spec.new do |spec|
  spec.name = "Segmentio"
  spec.version = "1.1.1"

  spec.homepage = "https://github.com/Yalantis/Segmentio"
  spec.summary = "Animated top/bottom segmented control written in Swift!"
  spec.screenshot = 'https://raw.githubusercontent.com/Yalantis/Segmentio/master/Assets/animation.gif'

  spec.author = "Yalantis"
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.social_media_url = "https://twitter.com/yalantis"

  spec.platform     = :ios, '8.0'
  spec.ios.deployment_target = '8.0'

  spec.source       = { :git => "https://github.com/Yalantis/Segmentio.git", :tag => spec.version }

  spec.source_files = 'Segmentio/Source/**/*.swift'
  spec.source_files.resource_bundles = {
    'Segmentio' => ['Pod/**/*.{storyboard,xib,xcassets,json,imageset,png}']
  }
  spec.module_name  = 'Segmentio'
  spec.requires_arc = true
end
