class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.1.tar.gz"
  sha256 "d87bcee58106eb8a79b850e9abc153d98b79e00d50eade0d63917154984f2a15"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", :branch => "2.6.0", :shallow => false

  bottle do
    rebuild 1
    sha256 "751351a1e214149d30af3aac83a6ddee9c16eb1c88f4c558fb1b0a7c872bbc99" => :mojave
    sha256 "bebdda05252dd770b59b06d52f47df761f3bfee8a4f076ffbbfc5790380ef5ca" => :high_sierra
    sha256 "1a561db3e60cbe31ddcb57da00ecb7e2e7298f9f6b6ea23cd8dda63d24fb757c" => :sierra
    sha256 "f55a5a83a6aeb56262dbebd09ba3531747ecc7ddb8875053d9e5e7a24642da34" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  needs :cxx11

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system "#{bin}/task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end
