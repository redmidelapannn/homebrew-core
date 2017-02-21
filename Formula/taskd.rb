class Taskd < Formula
  desc "Client-server synchronization for todo lists"
  homepage "https://taskwarrior.org/docs/taskserver/setup.html"
  url "https://taskwarrior.org/download/taskd-1.1.0.tar.gz"
  sha256 "7b8488e687971ae56729ff4e2e5209ff8806cf8cd57718bfd7e521be130621b4"
  revision 1

  head "https://git.tasktools.org/scm/tm/taskd.git"

  bottle do
    rebuild 1
    sha256 "79e87a9ab67cd58e741483088724ba5a4ca94442f7a1194bd0af86abe7554de3" => :sierra
    sha256 "f0a78b3480897b575c1d78e3616f6ec6222891560f6405f584bfc9750ffee1c5" => :el_capitan
    sha256 "6876dc85ffa6d3d3d9e5c9d5074599284824e4f274e1767da6c3665413ca223b" => :yosemite
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
