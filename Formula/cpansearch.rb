class Cpansearch < Formula
  desc "CPAN module search written in C"
  homepage "https://github.com/c9s/cpansearch"
  url "https://github.com/c9s/cpansearch/archive/0.2.tar.gz"
  sha256 "09e631f361766fcacd608a0f5b3effe7b66b3a9e0970a458d418d58b8f3f2a74"
  head "https://github.com/c9s/cpansearch.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "45b0770c1d93ecc9ff3338c54914cb69fd9b4b76c7e7711e306fc15a0a3cb3ea" => :mojave
    sha256 "5dde5bbc3b82e219bc28f4ecf37a5b73704e5722f2b4a2090a6c7b627e71f92d" => :high_sierra
    sha256 "495c3366ef0ae010bbb9dc645b3845405ff83e9b632c795b1df16683b0ed6a44" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000

  def install
    system "make"
    bin.install "cpans"
  end

  test do
    output = shell_output("#{bin}/cpans --fetch https://cpan.metacpan.org/")
    assert_match "packages recorded", output
  end
end
