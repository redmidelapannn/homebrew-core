class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.7.0.tar.gz"
  sha256 "96f1dda6bc110a4aa7b15f097b45e47df7984da5d2486791091c1fc6cdfb2616"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6d8ea817e9f3f5998243f122d26a95c5e4e3a4a8653da4e14619d628a3a13a36" => :sierra
    sha256 "4ffcfdbe81b29a1d8479633453f369fa3c4d8407ed0f22ec198abd4920dfebac" => :el_capitan
    sha256 "39748e1135150c33f3878abffd7bcbc8e050c02f9140d386147c68aab3002d0e" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/watchexec"
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
