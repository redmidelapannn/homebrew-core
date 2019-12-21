class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "http://ephemeralpg.org"
  url "http://ephemeralpg.org/code/ephemeralpg-2.9.tar.gz"
  sha256 "09314fe7d7ba2c26fb02864b9ddc92a538bc53674200363e77bb53a2fc1c17be"

  bottle do
    cellar :any_skip_relocation
    sha256 "57d9e48fa538af3fe7c01f0c4b0ff10cf6cc6f3f2827f31850cb61ff473e7fda" => :catalina
    sha256 "537dbb19980fce982e2859e14852d31fb5f4f91fc62ef062dab427890bf334ce" => :mojave
    sha256 "fa778995e1b3d3adb26a3ebd0a584376dd85e5239cdf8417643cb2984040bb6c" => :high_sierra
    sha256 "23c036094f518eb3d98539e410ea95bbe237bda31b205f3741fb46bb7d5e32c5" => :sierra
    sha256 "fe44d3d4814322c408e59944d86d56214c6056547111957efdbf08e382d4672b" => :el_capitan
  end

  depends_on "postgresql"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end
