# Support for programming language

# Development Libraries
# Libraries often needed to compile gem native extensions, etc.
package 'libsqlite3-dev'

# Support for developing in various languages
include_recipe "aerostat::proglang_ruby"
include_recipe "aerostat::proglang_python"
include_recipe "aerostat::proglang_erlang"
include_recipe "aerostat::proglang_clojure"
include_recipe "aerostat::proglang_c"
include_recipe "aerostat::proglang_go"

