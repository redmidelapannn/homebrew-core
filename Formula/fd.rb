class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find."
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v5.0.0.tar.gz"
  sha256 "9788597334912d65e32c7d57ef7a0294cb8976dc52538c9048a77fbb8d12f755"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "128f2595acdff338280dd2b1b8d08d9dc5247670685d5e9e915aab8d1710e36e" => :high_sierra
    sha256 "4957d41a61b650116d2b37d330e1ca24412d6d014190ffb804c455f1908ccccb" => :sierra
    sha256 "ca0bb6fdeb38b14640093b885702e655ade9e6bda4acb65710fe3e195cfa9fad" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
