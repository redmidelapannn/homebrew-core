class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-2.9.tar.gz"
  sha256 "09314fe7d7ba2c26fb02864b9ddc92a538bc53674200363e77bb53a2fc1c17be"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3c01dc6a4107e29cf3255ff6e5647bfd5b56dacf38c526f6d0786115ddfaa10d" => :catalina
    sha256 "be4cc665110826e411727d0460c835fd089a29c5186024fcb88356c52bce9dc2" => :mojave
    sha256 "847601b3206e101d363b8405dd436b208f9560c1c2c5373ef1752f755294c8ae" => :high_sierra
  end

  depends_on "postgresql"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end
