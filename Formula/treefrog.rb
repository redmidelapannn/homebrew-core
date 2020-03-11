class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.28.0.tar.gz"
  sha256 "0cab2ea618821e683ab6f5161c958884bb0700f589914376485f2b6935ce75c1"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "b7fcfa807eb7d68c2938298cd445d688a1cf0f5f14436cfec7f5ecf51ade8f5e" => :catalina
    sha256 "4cbc7cf7c8866ca040d406a863b4f857444bf65cd2e07ed05294c50feb75bfd2" => :mojave
    sha256 "20645a982d8f5a309e0012a6b870ac5f09fa16b80d8bd6163252cf3376b07b0c" => :high_sierra
  end

  depends_on "cmake"
  depends_on :xcode => ["8.0", :build]
  depends_on :macos => :el_capitan
  depends_on "qt"

  def install
    system "./configure", "--prefix=#{prefix}"

    cd "src" do
      system "make"
      system "make", "install"
    end

    cd "tools" do
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"tspawn", "new", "hello"
    assert_predicate testpath/"hello", :exist?
    cd "hello" do
      assert_predicate Pathname.pwd/"hello.pro", :exist?
      system HOMEBREW_PREFIX/"opt/qt/bin/qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
