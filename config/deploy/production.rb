set :domain, 'gamma.forset.ge'
set :user, 'deploy'
set :application, 'Mecnieri'
# easier to use https; if you use ssh then you have to create key on server
set :repository, 'https://github.com/ForSetGeorgia/mecnieri.me.git'
set :branch, 'master'
set :web_url, 'mecnieri.me'
set :secondary_web_url, 'www.mecnieri.me'
set :use_ssl, true
set :puma_worker_count, '1'
set :puma_thread_count_min, '1'
set :puma_thread_count_max, '3'
