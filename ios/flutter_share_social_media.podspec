#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_share_social_media'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin for share image and text in social media'
  s.description      = <<-DESC
A new Flutter plugin for share image and text in social media
                       DESC
  s.homepage         = 'https://github.com/jayarajm/flutter_share_social_media.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'jayarajm' => 'rajjaya566@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'FacebookCore'
  s.dependency 'FacebookShare'

  s.ios.deployment_target = '8.0'
end
