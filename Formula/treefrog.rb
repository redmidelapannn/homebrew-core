class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.22.0.tar.gz"
  sha256 "0b9d79d0e17266ff603c1ff812289e8d2500d8f758d3c700ccc3aaad51e3751d"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    rebuild 1
    sha256 "efb034b201e31cd0e0ed05b3483e2d59a16395e20268ebb8be1cf9113c0f452a" => :mojave
    sha256 "a8a1d837430f2ba0a579faf3fddebaf4055b76d8f89d358fadd6be0cfbd366d3" => :high_sierra
    sha256 "22a69f087483eb25845832da3b82faeb40294ac6ff5f11af1f943902d9f5203e" => :sierra
  end

  option "with-mysql", "enable --with-mysql option for Qt build"
  option "with-postgresql", "enable --with-postgresql option for Qt build"
  option "with-qt", "build and link with QtGui module"

  deprecated_option "with-qt5" => "with-qt"

  depends_on :xcode => ["8.0", :build]
  depends_on :macos => :el_capitan

  qt_build_options = []
  qt_build_options << "with-mysql" if build.with?("mysql")
  qt_build_options << "with-postgresql" if build.with?("postgresql")
  depends_on "qt" => qt_build_options

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-gui-mod" if build.with? "qt"

    system "./configure", *args

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
