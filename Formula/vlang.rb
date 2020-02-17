class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.24.tar.gz"
  sha256 "77ed24bf1c3c4eba057ace13bf0fff6fef6d9cdb3c2970f52b4be4582a148e2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "cccdfc809411c64c53d138b60709e8ff072a5f36885d540c6b33f2a5d1329da0" => :catalina
    sha256 "257137c3225c88b248e427d15371f2e083446f857df3042770be96a3f63fe7f4" => :mojave
    sha256 "7fcd17c8a9c59fe6bfb78a415b514e3fe083deba8922de83a28557b8efb6d5ae" => :high_sierra
  end

  resource "vc" do
    url "https://github.com/vlang/vc/archive/b9ea14b1f384b584b146ee59a8b179a1e2d68299.tar.gz"
    sha256 "e17e4ca81c365a25212e0879c02eaad5ee5dd86cb416444d998ea2061c35250a"
  end

  def install
    resource("vc").stage do
      system ENV.cc, "-std=gnu11", "-w", "-o", "v", "v.c", "-lm"
      libexec.install "v"
    end
    libexec.install "thirdparty", "tools", "vlib"
    bin.install_symlink libexec/"v" => "v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system "#{bin}/v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
