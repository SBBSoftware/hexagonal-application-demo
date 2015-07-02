# Load the Rails application.
require File.expand_path('../application', __FILE__)

Rails.application.configure do
  config.x.repository.module_prefix = 'Sbb::Repository'
end
# Initialize the Rails application.
Rails.application.initialize!
