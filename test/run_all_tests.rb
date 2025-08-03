# run all tests together!

Dir["#{__dir__}/**/*_test.rb"].each do |file|
  require file
end
