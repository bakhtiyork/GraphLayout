#
# Be sure to run `pod lib lint --use-libraries' to ensure this is a
# valid spec before submitting.
#
# Use `pod trunk push --use-libraries` to submit to Cocoapods repo

Pod::Spec.new do |s|
  s.name             = 'GraphLayout'
  s.version          = '0.1.0'
  s.summary          = 'GraphLayout - UI controls for  graph visualization. It is powered by Graphviz'

  s.description      = <<-DESC
GraphLayout - UI controls for  graph visualization. It is powered by Graphviz. Graph visualization is a way of representing structural information as diagrams of abstract graphs and networks.
                       DESC

  s.homepage         = 'https://github.com/bakhtiyork/GraphLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bakhtiyor Khodjaev' => 'pods@bakhtiyor.com' }
  s.source           = { :git => 'https://github.com/bakhtiyork/GraphLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.0'

  s.source_files = 'GraphLayout/Classes/**/*'
  s.libraries = 'z', 'stdc++'
  s.vendored_libraries = 'GraphLayout/lib/*.a'
end
