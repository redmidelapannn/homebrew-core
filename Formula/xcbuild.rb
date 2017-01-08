class Xcbuild < Formula
  desc "Xcode-compatible build tool"
  homepage "https://github.com/facebook/xcbuild"
  url "https://github.com/facebook/xcbuild.git",
      :tag => "0.1.0",
      :revision => "08575f65f1c907e280ed4663b5461b7cfaf5cfaa"
  head "https://github.com/facebook/xcbuild.git", :shallow => false

  bottle do
    cellar :any
    sha256 "f36c9fdea785cdfb57607e26057c1e80a99d996a2aa1869b3179abebcfd2fbdc" => :sierra
    sha256 "1086594f9d15478553a7e1eb5cbedbadf8711892feb82977ca8a19984c408cfa" => :el_capitan
    sha256 "ccc3c29603f92b60089d15617763187bb525d9042eb1f2d607637a8eef7ea923" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libpng" => :build
  depends_on "pkg-config" => :build
  depends_on "ninja" => :run

  def install
    system "cmake", ".", "-G", "Ninja", *std_cmake_args
    system "ninja", "install"
    bin.install_symlink "#{prefix}/usr/bin/xcbuild"
  end

  test do
    system "#{bin}/xcbuild", "-showsdks"
  end
end
