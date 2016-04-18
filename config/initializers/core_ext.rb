Dir.glob(File.join(Rails.root, 'lib', '*_ext', '*.rb')) do |file|
    load file
end