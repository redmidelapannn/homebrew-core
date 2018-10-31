class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.12.0/qbs-src-1.12.0.tar.gz"
  sha256 "5efeb2492f8ccf0e7a5ea106f748e1c536f964674025aecb22c1ee948e3e35d1"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "782fde71ae62e2cdd65d43d1e87f0b9ac1cabe2d3664965db7d3dc77b89f7d27" => :mojave
    sha256 "5c8cfea298aa8e95defcc1b1a429cb5a2954b2ec375dd3fd266dabafe6eb0b16" => :high_sierra
    sha256 "d8744f1cbf23b441f56bc784267609c0597354840733b1ac9a20e24c8c5404cd" => :sierra
  end

  depends_on "qt"

  def install
    system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=#{prefix}", "CONFIG+=qbs_disable_rpath"
    system "make", "install", "INSTALL_ROOT=/"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end
