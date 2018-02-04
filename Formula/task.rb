class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.1.tar.gz"
  sha256 "d87bcee58106eb8a79b850e9abc153d98b79e00d50eade0d63917154984f2a15"

  head "https://github.com/GothenburgBitFactory/taskwarrior.git", :branch => "2.6.0", :shallow => false

  bottle do
    rebuild 1
    sha256 "c61d0c0b4993daf5cbc1ee450cfda156be3caf7af2e1d8e07f0a63db59272956" => :high_sierra
    sha256 "b27dd1cbeea3c4747c4e27d670a252e197036462835eecc5dff3253742766265" => :sierra
    sha256 "4b7b65fd26fcb680ab6ee7d63ed9d50eadd5ed1598222495a42ff45bc914fe5e" => :el_capitan
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
