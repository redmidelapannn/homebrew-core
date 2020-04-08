class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.2.1.tar.gz"
  sha256 "f83eb44e2b21b070a7568b2b234e269a6ab7c64007728d62b01487de843688ee"

  bottle do
    cellar :any
    sha256 "85a68a575debebfc4429083df5e6eb8d1ab46c84ad3d2982deffe1d88502fa57" => :catalina
    sha256 "db79e89a8c122cf2074d37c4834b6cd3869e796ee36639af369f3e900927a8a5" => :mojave
    sha256 "0b5758e40c16b25ef26b44226ee475fdd1670bd19d34cd3a6881ae91a165a628" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :xcode => :build
  depends_on "qt"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lqxmpp
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <qxmpp/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
