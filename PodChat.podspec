
Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '10.0'

  s.name         = "PodChat"
  s.version      = "1.0.11"
  s.summary      = "PodChat classes"
  s.description  = <<-DESC
  A bunch of classes i have found useful for PodChat
                   DESC

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Etienne Goulet-Lang" => "" }
  s.source       = { :git => "https://github.com/egouletlang/PodChat.git", :tag => "#{s.version}" }

  s.homepage = "https://github.com/egouletlang/PodChat"

  s.source_files  = "PodChat", "PodChat/**/*.{h,m}", "PodChat/**/*.{swift}"
  s.exclude_files = "Classes/Exclude"

  s.dependency 'BaseUtils'
  s.dependency 'PodUI'
  s.dependency 'PodSpeech'

end

