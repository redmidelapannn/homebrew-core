class Maclock < Formula
  desc "Triggers Immediate screen lock on macOS"
  homepage "https://github.com/jcostom/maclock"
  url "https://github.com/jcostom/maclock/archive/1.0.tar.gz"
  sha256 "a0b8090e7bcf3b3cabc20d6e9fe2536f0d06f74e7a2367c2fea9cccbc5b16a24"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab56c5268a07a62ee9ca27b08ec8a863e237f4cbfd69218147f5b90db1a0a5f0" => :sierra
    sha256 "a6f7d280f3c0d99d8df76c2ad7f1a7926bac2b1a58cb49f1ba496992e9cc2b0f" => :el_capitan
    sha256 "3b1b7bcba42d079ee9c97081c3ecf506137b1759c3b3076174e8c47f3803b9be" => :yosemite
  end

  def install
    system ENV.cc, "-framework", "Foundation", "maclock.m", "-o", "maclock"
    bin.install "maclock"
  end
  test do
    # A dummy test definition
    # As the program is quite trivial, not a lot to test here, unless
    # we want to lock your screen. :-)
    system "true"
  end
end
