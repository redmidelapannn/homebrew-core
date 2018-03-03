class SfPwgen < Formula
  desc "Generate passwords using SecurityFoundation framework"
  homepage "https://github.com/anders/pwgen/"
  url "https://github.com/anders/pwgen/archive/v1.4.tar.gz"
  sha256 "1f4c7f514426305be2e1b893a586310d579e500e033938800afd2c98fedb84d9"

  head "https://github.com/anders/pwgen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "331f9f0d913cccd80cd617295a2dc1f02b00d8cf8ff8155e803d48e7228ab035" => :high_sierra
    sha256 "1afb8dfd1c0b5f635232679435da8f6a299c941bf17185ec6f49aeff941d871c" => :sierra
    sha256 "b625e9a25f8de6b733f01a80e8069683a0d028320fbc8d35e8b6e8e8d35cf5ea" => :el_capitan
  end

  depends_on :macos => :mountain_lion

  def install
    system "make"
    bin.install "sf-pwgen"
  end

  test do
    assert_equal 20, shell_output("#{bin}/sf-pwgen -a memorable -c 1 -l 20").chomp.length
  end
end
