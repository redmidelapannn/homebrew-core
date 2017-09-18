class Ctunnel < Formula
  desc "Cryptographic or plain tunnels for TCP/UDP connections"
  homepage "https://github.com/alienrobotarmy/ctunnel"
  url "https://www.alienrobotarmy.com/ctunnel/0.7/ctunnel-0.7.tar.gz"
  sha256 "3c90e14af75f7c31372fcdeb8ad24b5f874bfb974aa0906f25a059a2407a358f"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "8d53bd720db0545ff8e6cefc5081f363f7cf4f4cac9c201c0210fcc08cc42f7e" => :sierra
    sha256 "5d47a24a9d6f9c1699cf84167ddfe85647e8f5afc2074a27c17479a423d9b9bc" => :el_capitan
  end

  depends_on "openssl"
  depends_on :tuntap => :optional

  def install
    inreplace "Makefile.cfg", "TUNTAP=yes", "TUNTAP=no" if build.without? "tuntap"
    system "make"
    bin.mkpath
    system "make", "-B", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ctunnel", "-h"
  end
end
