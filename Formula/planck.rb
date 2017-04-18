class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.2.0.tar.gz"
  sha256 "99d37253de53df25260c41db95cc65ee39a4209690c3814a1c5693a3cdf0c9cc"
  revision 1
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "7e7e602d88944c964473e8520480b66089e63ad4b202f6bb1a7738abef8f1346" => :sierra
    sha256 "db08e0bfca440a7ae689e8fe0729e10672c5fea908c47cb50670c669fb27b5c7" => :el_capitan
    sha256 "8d4d0471c6d938f97d047fa5a6c87f80be07c68b7608e054f221383223eaff84" => :yosemite
  end

  depends_on "libzip"
  depends_on "icu4c"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
