class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.19.0.tar.gz"
  sha256 "bb33984f986a7ac68b331cfd64bd0f9e41daf5391b1a36e158e15d94d886dd04"
  revision 1
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "439b780c82653299b348634d75e3c3bdde135e96a9cdf8040979fac0591b9dd2" => :mojave
    sha256 "a1db7b29a513e076c261b73fa9c12e877a4b7f14a0e9b497fc274cf78f55b02e" => :high_sierra
    sha256 "4708cfe2e669bd7192ae7ea99e93d7003d8705a1664152ae139fb48585a8d4fe" => :sierra
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "icu4c"
  depends_on "libzip"

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
    bin.install "planck-sh/plk"
    man1.install Dir["planck-man/*.1"]
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
