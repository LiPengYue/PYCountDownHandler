
Pod::Spec.new do |s|
  s.name             = 'PYCountDownHandler'
  s.version          = '0.1.1'
  s.summary          = '关于倒计时的管理工具'


  s.description      = <<-DESC
    高性能列表 倒计时的管理工具
                       DESC

  s.homepage         = 'https://github.com/LiPengYue/PYCountDownHandler'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiPengYue' => '702029772@qq.com' }
  s.source           = { :git => 'https://github.com/LiPengYue/PYCountDownHandler.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PYCountDownHandler/Classes/**/*'

end
