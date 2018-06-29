Pod::Spec.new do |s|
	s.name = 'Preferences'
	s.version = '0.1.0'
	s.license = { :type => 'MIT', :file => 'license' }
	s.homepage = 'https://github.com/sindresorhus/Preferences'
	s.social_media_url = 'https://twitter.com/sindresorhus'
	s.authors = { 'Sindre Sorhus' => 'sindresorhus@gmail.com' }
	s.summary = 'Add a preferences window to your macOS app in minutes'
	s.source = { :git => 'https://github.com/sindresorhus/Preferences.git', :tag => "v#{s.version}" }
	s.source_files = 'Sources/**/*.swift'
	s.swift_version = '4.1'
	s.platform = :osx, '10.12'
end
