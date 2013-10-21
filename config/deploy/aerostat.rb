#!/usr/bin/env ruby

server "#{stage}", :chef, :no_release => :true
set :server_ip, "#{stage}"
before "multistage:ensure","warning:warning"
