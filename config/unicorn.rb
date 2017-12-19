APP_PATH = "/home/ec2-user/hunhem_board"
worker_processes 4

working_directory APP_PATH

listen APP_PATH + "/tmp/sockets/unicorn.sock", :backlog => 64
listen 8080, :tcp_nopush => true

timeout 30

pid APP_PATH + "/tmp/pids/unicorn.pid"

stderr_path APP_PATH + "/log/unicorn.stderr.log"
stdout_path APP_PATH + "/log/unicorn.stdout.log"

preload_app true

check_client_connection false

run_once = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false
  end

end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

end
