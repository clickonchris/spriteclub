# config/initializers/load_config.rb
SPRITECLUB = YAML.load_file("#{RAILS_ROOT}/config/spriteclub.yml")[RAILS_ENV]

puts "cavnvas is " + SPRITECLUB['canvas_name']