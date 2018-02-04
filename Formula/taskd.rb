class Taskd < Formula
  desc "Client-server synchronization for todo lists"
  homepage "https://taskwarrior.org/docs/taskserver/setup.html"
  url "https://taskwarrior.org/download/taskd-1.1.0.tar.gz"
  sha256 "7b8488e687971ae56729ff4e2e5209ff8806cf8cd57718bfd7e521be130621b4"
  revision 1

  head "https://github.com/GothenburgBitFactory/taskserver.git"

  bottle do
    rebuild 1
    sha256 "9922dd74c40b0c3b5ae98c5403b2216c875861d9cb8d4593eed2296496f6fba6" => :high_sierra
    sha256 "717f7302bad0400c5a65323c7b377d944e3b218233cd367c2a471964fad37634" => :sierra
    sha256 "8d0f84841d1b7e558003eb10be7f94f3e4a60e97cb895a74fb4cbc2b4c2dcc23" => :el_capitan
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
