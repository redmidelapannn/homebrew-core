class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v7.0.0.tar.gz"
  sha256 "93cc5a7c9199dc650f51a491e4ed4512262eeaeae5847722e6886763b41e2896"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    rebuild 1
    sha256 "1a1f6442405866454bea13d92f6d38b2410e81278e8c95ab532a6dc6ab811d54" => :high_sierra
    sha256 "55c9a7a5b39d03d77207d99639013254858f38e2c8c5755ae1381555ad8f50da" => :sierra
    sha256 "a4bbb760fa9c4d1189e350703783a7acb6ad9b9172c2f6dc89ecb2322bfc941d" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash"
    fish_completion.install "fd.fish"
    zsh_completion.install "_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
