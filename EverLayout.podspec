Pod::Spec.new do |s|
  s.name         = "EverLayout"
  s.version      = "0.2.0"
  s.summary      = "Reusable, downloadable, up-datable iOS layouts"

  s.homepage     = "https://github.com/acrocat/EverLayout"

  s.license      = "LICENSE"

  s.author       = { "Dale Webster" => "sterdefs@gmail.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/acrocat/EverLayout.git", :tag => "#{s.version}" }

  s.source_files  = "EverLayout", "EverLayout/**/*.{swift}"

  s.dependency "Socket.IO-Client-Swift" , "8.2.0"
end
