class Xcbuild < Formula
  desc "Xcode-compatible build tool"
  homepage "https://github.com/facebook/xcbuild"
  url "https://github.com/facebook/xcbuild.git", :tag => "0.1.0", :revision => "08575f65f1c907e280ed4663b5461b7cfaf5cfaa"
  head "https://github.com/facebook/xcbuild.git", :shallow => false

  bottle do
    cellar :any
    sha256 "a9a3a80e61cb4bb2c1876988f9e8926231464e0b2e62396171910309d35f949a" => :sierra
    sha256 "3bfb054df58f93337c2bdd4f483284cecd1c00c90adefafbad7d033964a7c1f7" => :el_capitan
    sha256 "0ece669ecda18cff4e2774eff985bba82d095b41c42ca5f38bf1fe9d50132376" => :yosemite
  end

  depends_on "ninja"
  depends_on "cmake"
  depends_on "libpng"
  depends_on "pkg-config"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    bin.install_symlink "#{prefix}/usr/bin/xcbuild"
  end

  test do
    system "#{bin}/xcbuild", "-showsdks"
  end
end
