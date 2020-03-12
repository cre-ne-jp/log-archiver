# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

use Unicorn::WorkerKiller::MaxRequests, 1024, 2048, true
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2))
