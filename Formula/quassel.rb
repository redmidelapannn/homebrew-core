class Quassel < Formula
  desc "Distributed IRC client (Qt-based)"
  homepage "http://www.quassel-irc.org/"
  head "https://github.com/quassel/quassel.git"

  stable do
    url "http://www.quassel-irc.org/pub/quassel-0.12.2.tar.bz2"
    sha256 "6bd6f79ecb88fb857bea7e89c767a3bd0f413ff01bae9298dd2e563478947897"

    # Fix Qt 5.5 build failure.
    patch do
      url "https://github.com/quassel/quassel/commit/078477395aaec1edee90922037ebc8a36b072d90.patch"
      sha256 "85adfbe4613688d0f282deb5250fb39f7534d9e6ac7450cf035cca7bbcb25cda"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "6197868a65aaed01e5582383f29effe5fc47ce6c2a6cd1a0d94a6891a80ffda7" => :el_capitan
    sha256 "db15e2d5dd02ddc0d3da9732abbf5c99a5790ebcc08e4e905d93c3b68a98a845" => :yosemite
    sha256 "c111b5ae31b04d717991117ffbeaa37ba5cd42c7655c9ea6c27d8f9eb201f9aa" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt5" => :recommended

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "."
    args << "-DUSE_QT5=ON" if build.with? "qt5"

    system "cmake", *args
    system "make", "install"
  end

  test do
    assert_match /Quassel IRC/, shell_output("#{bin}/quasselcore -v", 1)
  end
end
