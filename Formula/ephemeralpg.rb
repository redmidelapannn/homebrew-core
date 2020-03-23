class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-2.9.tar.gz"
  sha256 "09314fe7d7ba2c26fb02864b9ddc92a538bc53674200363e77bb53a2fc1c17be"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5090627334cce8a0a5973801e5cd262f85d75a3832b6f7c61de95058da5280ec" => :catalina
    sha256 "0e1f8c58ae1437d7101a87f9cb2848eba114317390bd8dea463222b69caf5562" => :mojave
    sha256 "c2982a8e8836bc038f3ed3615194584f79503ce64283ab70cf17d7656da4ac9f" => :high_sierra
  end

  depends_on "postgresql"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    return if ENV["CI"]

    system "#{bin}/pg_tmp", "selftest"
  end
end
