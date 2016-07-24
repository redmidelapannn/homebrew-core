class Xcbuild < Formula
  desc "Xcode-compatible build tool"
  homepage "https://github.com/facebook/xcbuild"
  url "https://github.com/facebook/xcbuild.git",
    :tag => "0.1.0",
    :revision => "08575f65f1c907e280ed4663b5461b7cfaf5cfaa",
    :shallow => false
  head "https://github.com/facebook/xcbuild.git",
    :shallow => false

  bottle do
    cellar :any
    sha256 "bffe27ffb4abe23bcee003dcc1bf7cf1a4fecac3a304ab88bbb34c454ef36944" => :el_capitan
    sha256 "effa4ede437e6464d51a1f8ed12a1f708ea58d6582a72656a3faebfb157fee87" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libpng"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    bin.install_symlink "#{prefix}/usr/bin/xcbuild"
  end

  test do
    system "#{bin}/xcbuild", "-showsdks"
  end
end
