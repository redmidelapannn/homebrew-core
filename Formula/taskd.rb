class Taskd < Formula
  desc "Client-server synchronization for todo lists"
  homepage "https://taskwarrior.org/docs/taskserver/setup.html"
  url "https://taskwarrior.org/download/taskd-1.1.0.tar.gz"
  sha256 "7b8488e687971ae56729ff4e2e5209ff8806cf8cd57718bfd7e521be130621b4"
  revision 1

  head "https://github.com/GothenburgBitFactory/taskserver.git"

  bottle do
    rebuild 1
    sha256 "a566b812e155ce7b535cc1f49c5f7d0e32ac8ff1456001211844f1db0febe1dd" => :high_sierra
    sha256 "d0134bc6f8a3e11dcf066a25c0fe518760f842fab2b54e4de024372ed1ec206a" => :sierra
    sha256 "49bbb4b5931b00999b42b0acf06a6d480a039332d245a352bf8dba25b950c46a" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/taskd", "init", "--data", testpath
  end
end
