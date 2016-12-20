Pod::Spec.new do |s|
   s.name             = "JSBridge"
   s.version          = "0.2.2"
   s.summary          = "Make iOS and Android work in a same way"
   s.homepage         = "https://github.com/sun-fox-cj/JSBridge/tree/0.2"
   s.license          = { :type => "MIT", :file => "LICENSE" }
   s.author           = { "cjfire" => "cjfire@sina.cn" }
   s.source           = { :git => "https://github.com/sun-fox-cj/JSBridge.git", :tag => s.version}
   s.platform     = :ios, '6.0'
   s.requires_arc = true
   s.source_files = "JSBridge/JSBridge/**/*.{h,m}"
end