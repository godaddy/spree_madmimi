namespace :spree_madmimi do
  namespace :user do
    desc "Create Mad Mimi user"
    task :create => :environment do
      require File.join(File.dirname(__FILE__), '..', '..', 'db', 'seeds.rb')
    end
  end
end
