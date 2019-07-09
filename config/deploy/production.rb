set :stage, :production

server '206.189.198.11', roles: %w[app web db], primary: true, user: 'deployer'
set :rails_env, 'production'
