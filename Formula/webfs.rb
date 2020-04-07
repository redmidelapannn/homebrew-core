class Webfs < Formula
  desc "HTTP server for purely static content"
  homepage "http://linux.bytesex.org/misc/webfs.html"
  url "https://www.kraxel.org/releases/webfs/webfs-1.21.tar.gz"
  sha256 "98c1cb93473df08e166e848e549f86402e94a2f727366925b1c54ab31064a62a"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "9f30c00dc8015a43e964136ad525fe94393c80f73eda08f9a82151a049dc9d9a" => :catalina
    sha256 "6238121c023b7dde0b76999b248decdae3e004e1d45792dabf956fefc75280dc" => :mojave
    sha256 "40486adb8a77f39ade22547c484605e5ccd49d74b2ae578685f860c6ea2ab8e7" => :high_sierra
  end

  depends_on "openssl@1.1"

  patch :p0 do
    url "https://github.com/Homebrew/formula-patches/raw/0518a6d1ed821aebf0de4de78e39b57d6e60e296/webfs/patch-ls.c"
    sha256 "8ddb6cb1a15f0020bbb14ef54a8ae5c6748a109564fa461219901e7e34826170"
  end

  def install
    ENV["prefix"]=prefix
    system "make", "install", "mimefile=/etc/apache2/mime.types"
  end

  test do
    port = free_port
    pid = fork { exec bin/"webfsd", "-F", "-p", port.to_s }
    sleep 5
    assert_match %r{webfs\/1.21}, shell_output("curl localhost:#{port}")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
