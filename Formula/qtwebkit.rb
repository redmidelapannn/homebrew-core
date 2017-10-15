class Qtwebkit < Formula
  desc "Qt port of WebKit"
  homepage "https://trac.webkit.org/wiki/QtWebKit"
  url "https://download.qt.io/official_releases/qt/5.9/5.9.1/submodules/qtwebkit-opensource-src-5.9.1.tar.xz"
  sha256 "28a560becd800a4229bfac317c2e5407cd3cc95308bc4c3ca90dba2577b052cf"

  bottle do
    cellar :any
    sha256 "902b0ed34a16c5a180501ab1f607ace60bb26f1027be9d876366e9a0bfd934bc" => :high_sierra
    sha256 "f3a3d07d9fb213ff3cdd26fc6b6fa186a6326b979310a45acc990b0a6fab85ef" => :sierra
    sha256 "326baeee4b7b6581cea9ef6ae0b226a5d898f01b5ca24d185cd8a7e5b0c4fcad" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt"

  def install
    cd "Tools/Scripts" do
      system "./set-webkit-configuration", "--release"
      system "./build-webkit", "--release", "--qt"
    end

    cd buildpath/"WebKitBuild/Release" do
      qt_prefix = "#{HOMEBREW_PREFIX}/Cellar/qt/#{Formula["qt"].version}"
      inreplace "lib/pkgconfig/Qt5WebKit.pc", qt_prefix, opt_prefix.to_s
      inreplace "lib/pkgconfig/Qt5WebKitWidgets.pc", qt_prefix, opt_prefix.to_s
      bad_prefix = "\$\(INSTALL_ROOT\)" << qt_prefix
      inreplace "Source/Makefile.api", bad_prefix, prefix.to_s
      inreplace "Source/Makefile.widgetsapi", bad_prefix, prefix.to_s
      inreplace "Source/WebKit2/Makefile.WebProcess", bad_prefix, prefix.to_s
      inreplace "Source/WebKit/qt/declarative/Makefile.declarative.public", bad_prefix, prefix.to_s
      inreplace "Source/WebKit/qt/declarative/experimental/Makefile.declarative.experimental", bad_prefix, prefix.to_s
      inreplace "Source/WebKit2/UIProcess/API/qt/tests/qmltests/Makefile.DesktopBehavior", bad_prefix, prefix.to_s
      inreplace "Source/WebKit2/UIProcess/API/qt/tests/qmltests/Makefile.WebView", bad_prefix, prefix.to_s
      system "make", "install"
    end
    rm_f "tests"
    include.install_symlink lib/"QtWebKit.framework/Headers" => "QtWebKit"
    include.install_symlink lib/"QtWebKitWidgets.framework/Headers" => "QtWebKitWidgets"
  end

  def caveats; <<-EOS.undent
    We agreed to the WebKit opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end

  test do
    TestBrowser = fork do
      exec "#{bin}/QtTestBrowser", "https://brew.sh"
    end

    sleep 5

    Process.kill("TERM", TestBrowser)
  end
end
