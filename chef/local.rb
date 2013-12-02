#!/usr/bin/env ruby

root = File.absolute_path(File.dirname(__FILE__))

chef_repo_path root
cookbook_path ["#{root}/cookbooks","#{root}/site-cookbooks"]
