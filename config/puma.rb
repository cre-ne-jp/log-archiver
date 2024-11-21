# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.
#
# Puma starts a configurable number of processes (workers) and each process
# serves each request in a thread from an internal thread pool.
#
# You can control the number of workers using ENV["WEB_CONCURRENCY"]. You
# should only set this value when you want to run 2 or more workers. The
# default is already 1.
#
# The ideal number of threads per worker depends both on how much time the
# application spends waiting for IO operations and on how much you wish to
# prioritize throughput over latency.
#
# As a rule of thumb, increasing the number of threads will increase how much
# traffic a given process can handle (throughput), but due to CRuby's
# Global VM Lock (GVL) it has diminishing returns and will degrade the
# response time (latency) of the application.
#
# The default is set to 3 threads as it's deemed a decent compromise between
# throughput and latency for the average Rails application.
#
# Any libraries that use a connection pool or another resource pool should
# be configured to provide at least as many connections as the number of
# threads. This includes Active Record's `pool` parameter in `database.yml`.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
if ENV.fetch("RAILS_ENV", "development") == "development"
  bind "tcp://0.0.0.0:3000"
else
  port ENV.fetch("PORT") { 8081 }
  #bind "unix://#{rails_root}/tmp/sockets/puma.sock"
end

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# pumactl で操作する為に必要なファイル
state_path "#{rails_root}/tmp/pids/puma.state"

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# ログファイルのパス
stdout_redirect(
  "#{rails_root}/log/puma_stdout.log",
  "#{rails_root}/log/puma_stderr.log",
  true
) unless ENV.fetch("RAILS_ENV", "development") == "development"

# Run the Solid Queue supervisor inside of Puma for single-server deployments
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
# In other environments, only set the PID file if requested.
pidfile File.expand_path('../../tmp/pids/puma.pid', __FILE__) unless ENV["PIDFILE"]

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers 
# together concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
workers ENV.fetch("WEB_CONCURRENCY") { 3 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
preload_app!

before_fork do
  # If you are preloading your application and using Active Record, it's
  # recommended that you close any connections to the database before workers
  # are forked to prevent connection leakage.
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  # 定期的に worker プロセスを KILL して、全体のメモリ使用量を減らす
  PumaWorkerKiller.config do |c|
    c.ram = ENV.fetch("PUMA_WORKER_MEMORY_LIMIT") { 1024 }
    c.frequency = ENV.fetch("PUMA_WORKER_CHECK_FREQUENCY") { 5 }
    c.percent_usage = ENV.fetch("PUMA_WORKER_PERCENT_USAGE") { 0.65 }
    c.rolling_restart_frequency = ENV.fetch("PUMA_WORKER_RESTART_FREQUENCY") { 24 * 3600 }
    c.reaper_status_logs = ENV.fetch("PUMA_WORKER_REAPER_STATUS_LOGS") { |k|
      true if k == "true"
    }
  end
  PumaWorkerKiller.start
end

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted, this block will be run. If you are using the `preload_app!`
# option, you will want to use this block to reconnect to any threads
# or connections that may have been created at application boot, as Ruby
# cannot share connections between processes.
# process behavior so workers use less memory.
#
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
