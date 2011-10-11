require "rvm/capistrano"
require "bundler/capistrano"

# アプリケーション名
set :application, "conf-in"
# リポジトリの場所
set :repository,  "ssh://git@falconsrv.net/home/conf-in/conf-in-procon.git"
# デプロイ先
set :deploy_to,  "/var/www/rails/#{application}"

# Git
set :scm, :git
set :branch, "master"
set :scm_verbose, true

# 設置するアカウント
set :user, "falcon"
set :use_sudo, false
set :rvm_ruby_string, "ruby-1.9.2-p290"
set :rvm_type, :user

# 公開先
set :domain, "conf-in.falconsrv.net"
role :web, domain # 公開サーバ
role :app, domain # 設置サーバ
role :db,  domain, :primary => true # プライマリDBサーバ

# デプロイ時の動作
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
