class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.16.0.tar.gz"
  sha256 "b125f2b45d65423c6affd2fd7c60c8534de6d85d06a25d8b65035e4bdb79e73b"
  revision 1
  head "https://github.com/treefrogframework/treefrog-framework.git", :branch => "master"

  bottle do
    sha256 "130961deef7c8edb75dd63058d5ab806cc6f8bc304ffc503e404b784a218f8c9" => :sierra
    sha256 "19f5c45e302261e2bb7eb9efcbf4330fe36b4ca7ba1287c4297c81f4acc3083e" => :el_capitan
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-mysql", "enable --with-mysql option for Qt build"
  option "with-postgresql", "enable --with-postgresql option for Qt build"
  option "with-qt", "build and link with QtGui module"

  depends_on :macos => :el_capitan
  depends_on :xcode => [:build, "8.0"]

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
    assert File.exist?("hello")
    cd "hello" do
      assert File.exist?("hello.pro")
      system HOMEBREW_PREFIX/"opt/qt/bin/qmake"
      assert File.exist?("Makefile")
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
