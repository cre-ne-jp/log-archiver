# 参考: http://nekorails.hatenablog.com/entry/2018/10/12/101011

# Rails のルートパス
rails_root = File.expand_path('../../', __FILE__)

directory rails_root

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
if ENV.fetch("RAILS_ENV", "development") == "development"
  bind "tcp://0.0.0.0:3000"
else
  port        ENV.fetch("PORT") { 8081 }
  #bind        "unix://#{rails_root}/tmp/sockets/puma.sock"
end

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# pumactl で操作する為に必要なファイル
state_path "#{rails_root}/tmp/pids/puma.state"

# ログファイルのパス
stdout_redirect(
  "#{rails_root}/log/puma_stdout.log",
  "#{rails_root}/log/puma_stderr.log",
  true
) unless ENV.fetch("RAILS_ENV", "development") == "development"

# pid ファイルのパス
pidfile File.expand_path('../../tmp/pids/puma.pid', __FILE__)

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch("WEB_CONCURRENCY") { 3 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
#
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

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
