# C

# Install glibc's debuginfo and latest Valgrind from source.
package 'libc6-dbg'
ark 'valgrind' do
  url 'http://valgrind.org/downloads/valgrind-3.8.1.tar.bz2'
  action :install_with_make
  not_if do ::File.exists?('/usr/local/bin/valgrind') end
end

# LLVM and clang for fun, new LLVM/clang-stuff
package "llvm"
package "clang"
