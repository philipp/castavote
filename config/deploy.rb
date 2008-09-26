set :application, "castavote"

default_run_options[:pty] = true
set :repository,  "git://github.com/dmitryame/castavote.git"
set :scm, "git"
# set :scm_passphrase, "p@ssw0rd" #This is your custom users password
set :user, "deployer"

# ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
# set :git_shallow_clone, 1

# set :deploy_to, "/u/apps/#{application}"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "echowaves.com"
role :web, "echowaves.com"
role :db,  "echowaves.com", :primary => true