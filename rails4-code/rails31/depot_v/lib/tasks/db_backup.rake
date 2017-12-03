# encoding: utf-8
namespace :db do

  desc "本番用データベースをバックアップする"
  task :backup => :environment do
    backup_dir  = ENV['DIR'] || File.join(Rails.root, 'db', 'backup')

    source = File.join(Rails.root, 'db', "production.db")
    dest   = File.join(backup_dir, "production.backup")

    makedirs backup_dir, :verbose => true
    sh "sqlite3 #{source} .dump > #{dest}"
  end

end
