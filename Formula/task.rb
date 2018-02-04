class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.1.tar.gz"
  sha256 "d87bcee58106eb8a79b850e9abc153d98b79e00d50eade0d63917154984f2a15"

  head "https://github.com/GothenburgBitFactory/taskwarrior.git", :branch => "2.6.0", :shallow => false

  bottle do
    rebuild 1
    sha256 "9ec311975c446c576dfa871fe206ef7d5dae5b10beb9c9437de90c0b4fedeb41" => :high_sierra
    sha256 "27fce986ec745c311be98192e00580488e3ae2bd1ee7943205bd9e318bb0b406" => :sierra
    sha256 "2c1cc57fd525ce8b03cdfba4e046d302f7239aa385f6c5619af6ef0c805c1168" => :el_capitan
  end

  option "without-gnutls", "Don't use gnutls; disables sync support"

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended

  needs :cxx11

  def install
    args = std_cmake_args
    args << "-DENABLE_SYNC=OFF" if build.without? "gnutls"
    system "cmake", ".", *args
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
