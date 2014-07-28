if ENV['BOXEN_SOCKET_DIR'].nil?
  worker_processes 3
  timeout 30
  preload_app true
else
 if ENV['RACK_ENV'] == 'development'
    worker_processes 1
    listen "#{ENV['BOXEN_SOCKET_DIR']}/#{app_name}", :backlog => 1024
    timeout 120
  end

  after_fork do |server, worker|
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
end

