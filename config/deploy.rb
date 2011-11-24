$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
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
set :scm_verbose, true

# 設置するアカウント
set :use_sudo, false
set :rvm_type, :system

# 公開先
# テスト環境
task :staging do
	set :domain, "10.0.0.5"
	set :user, "falcon"
	set :rvm_ruby_string, "ruby-1.9.2-p290@rails3.1.1"
	set :branch, "release-localsrv"
	role :web, domain # 公開サーバ
	role :app, domain # 設置サーバ
	role :db,  domain, :primary => true # プライマリDBサーバ
end

# 本番環境
task :production do
	set :domain, "conf-in.com"
	set :user, "falcon"
	set :rvm_ruby_string, "ruby-1.9.2-p290@rails3.1.1"
	set :branch, "release-conf-in-falconsrv"
	role :web, domain # 公開サーバ
	role :app, domain # 設置サーバ
	role :db,  domain, :primary => true # プライマリDBサーバ
end

# デプロイ時の動作
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
