Pod::Spec.new do |s|

  s.name         = "TRTransitions"
  s.version      = "1.0"
  s.summary      = "Thomson Reuters iOS Custom Transitions Catalogue"

  s.description  = <<-DESC
  				   Catalogue for different custom animated transitions for iOS.
                   DESC
                   
# s.exclude_files = ""

  s.homepage     = "http://www.thomsonreuters.com"
  s.license      = { :type => 'Apache', :file => 'LICENSE.md' }
  s.authors      = { "Juanjo Ramos" => "jjramos.developer@gmail.com" }
  
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/thomsonreuters/TRTransitions-iOS" }
  s.source_files = 'TRTransitions/TRTransitions/**/*.{h,m}'
  
  s.requires_arc = true
# s.resource = ""

end