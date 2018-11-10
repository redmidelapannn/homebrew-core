class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.19.0.tar.gz"
  sha256 "bb33984f986a7ac68b331cfd64bd0f9e41daf5391b1a36e158e15d94d886dd04"
  revision 1
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "8922cf57550cb3cb024c673770225f351367ebfbf2aa7ca8ecf5b34592874662" => :mojave
    sha256 "5ea4a73d27f38e9f2985b6472566e1b5b3119bb59b5067416558827f1ec8a6df" => :high_sierra
    sha256 "7c2debe060be1335d9a2420eeac59ac58c5425fd61760bfdcddbb0d2ac2e0abe" => :sierra
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "icu4c"
  depends_on "libzip"
  depends_on :macos => :mavericks

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
