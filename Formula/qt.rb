# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"

  if MacOS.version <= :el_capitan
    url "https://download.qt.io/archive/qt/5.11/5.11.3/single/qt-everywhere-src-5.11.3.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.11/5.11.3/single/qt-everywhere-src-5.11.3.tar.xz"
    sha256 "859417642713cee2493ee3646a7fee782c9f1db39e41d7bb1322bba0c5f0ff4d"
  else
    url "https://download.qt.io/official_releases/qt/5.13/5.13.2/single/qt-everywhere-src-5.13.2.tar.xz"
    mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.13/5.13.2/single/qt-everywhere-src-5.13.2.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.13/5.13.2/single/qt-everywhere-src-5.13.2.tar.xz"
    sha256 "55e8273536be41f4f63064a79e552a22133848bb419400b6fa8e9fc0dc05de08"
  end

  head "https://code.qt.io/qt/qt5.git", :branch => "dev", :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "458bebc80cda444c9ae4965f1232443fb8cf24e507ecafb394e964cdb9568aa9" => :catalina
    sha256 "0d6e0be11ea602a0bca2a582a53ab471a5b4d7c0200100e8997aef1dc9946c91" => :mojave
    sha256 "f8c28a845005677406ba9ec60eabad9a437c6378fe2bce60411a6f01470f19a6" => :high_sierra
  end

  keg_only "Qt 5 has CMake issues when linked"

  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on :macos => :el_capitan

  def install
    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -system-zlib
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake examples
      -nomake tests
      -no-rpath
      -pkg-config
      -dbus-runtime
      -proprietary-codecs
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats; <<~EOS
    We agreed to the Qt open source license for you.
    If this is unacceptable you should uninstall.
  EOS
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_predicate testpath/"hello", :exist?
    assert_predicate testpath/"main.o", :exist?
    system "./hello"
  end
end
