class DtkcoreAT2 < Formula
  desc "Deepin Tool Kit Core Module"
  homepage "https://www.deepin.org"
  url "http://packages.deepin.com/deepin/pool/main/d/dtkcore/dtkcore_2.0.16.1.orig.tar.xz"
  sha256 "79b19a9b01f8a53d2794afa3073d3303b54d6e07da94cc1ef20eb32ea0c3f465"

  depends_on "pkg-config" => :build
  depends_on "qt"

  patch :DATA

  def install
    system "qmake", "PREFIX=#{prefix}", "DTK_VERSION=2.0.16.1", ".", "-r"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      CONFIG += c++11 link_pkgconfig
      PKGCONFIG += dtkcore
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <DObject>

      DCORE_USE_NAMESPACE

      class Test : public DObject {
          using DObject::DObject;
      };

      int main(int argc, char *argv[]) {
          QCoreApplication a(argc, argv);
          Test test;
          return 0;
      }
    EOS

    system "qmake", testpath/"hello.pro"
    system "make"
    assert_predicate testpath/"hello", :exist?
    assert_predicate testpath/"main.o", :exist?
    system "./hello"
  end
end

__END__
diff --git a/tests/dutiltester.cpp b/tests/dutiltester.cpp
index 9ccd992..b484da8 100644
--- a/tests/dutiltester.cpp
+++ b/tests/dutiltester.cpp
@@ -42,7 +42,12 @@ void TestDUtil::testLogPath()
     qApp->setApplicationName("deepin-test-dtk");

     DPathBuf logPath(QStandardPaths::standardLocations(QStandardPaths::HomeLocation).first());
+
+#ifdef Q_OS_OSX
+    logPath = logPath / "Library" / "Caches" / "deepin" / "deepin-test-dtk" / "deepin-test-dtk.log";
+#else
     logPath = logPath / ".cache" / "deepin" / "deepin-test-dtk" / "deepin-test-dtk.log";
+#endif

     QCOMPARE(DLogManager::getlogFilePath(), logPath.toString());
 }
