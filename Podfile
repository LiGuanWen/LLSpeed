
platform:ios,'8.0'
target ‘LLSpeed’ do
    pod 'LLSpeed', :path => '.'
    pod 'LLRoute', :git => 'https://github.com/LiGuanWen/LLRoute.git'
    pod 'FDFullscreenPopGesture', '~> 1.1'

#    pod 'LLKit', :git => 'https://github.com/LiGuanWen/LLKit.git', :branch => '1.0.0'
end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-LLSpeed/Pods-LLSpeed-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end
