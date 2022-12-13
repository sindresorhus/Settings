Pod::Spec.new do |s|
  s.name = "Preferences"
  s.version = "2.6.0"
  s.summary = "⚙ Add a settings window to your macOS app in minutes"

  s.homepage = "https://github.com/sindresorhus/Preferences"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Sindre Sorhus" => "sindresorhus@gmail.com" }
  s.source = { :git => "https://github.com/sindresorhus/Preferences.git", :tag => s.version.to_s }

  s.osx.deployment_target = "10.13"

  s.swift_version = "5.0"

  s.source_files = "Sources/Preferences/**/*"
end
