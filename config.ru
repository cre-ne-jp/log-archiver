# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

if defined?(Unicorn)
  require 'unicorn/worker_killer'

  auto_restart_verbose =
    ENV['UNICORN_AUTO_RESTART_VERBOSE'].to_s.downcase == 'true'

  max_requests = {
    min: ENV['UNICORN_MAX_REQUESTS_MIN']&.to_i || 1024,
    max: ENV['UNICORN_MAX_REQUESTS_MAX']&.to_i || 2048
  }.freeze
  use Unicorn::WorkerKiller::MaxRequests, max_requests[:min], max_requests[:max], auto_restart_verbose

  oom = {
    min: ((ENV['UNICORN_OOM_MIN']&.to_i || 192) * (1024 ** 2)),
    max: ((ENV['UNICORN_OOM_MAX']&.to_i || 256) * (1024 ** 2)),
    check_cycle: ENV['UNICORN_OOM_CHECK_CYCLE']&.to_i || 16
  }.freeze
  use Unicorn::WorkerKiller::Oom, oom[:min], oom[:max], oom[:check_cycle], auto_restart_verbose
end

require_relative 'config/environment'
run Rails.application
Rails.application.load_server
