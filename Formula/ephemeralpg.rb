class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "http://ephemeralpg.org"
  url "http://ephemeralpg.org/code/ephemeralpg-1.9.tar.gz"
  mirror "https://bitbucket.org/eradman/ephemeralpg/get/ephemeralpg-1.9.tar.gz"
  sha256 "3caf06f2be5d9f206f3c1174cc0c44cc359357fc7d41da026f858e01ef192792"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d42fc1a38a5617fd146b3ce4f0b5fb61006e3ea1f862495448b026df1e0dd0c2" => :sierra
    sha256 "d1ec411085ca95d221f6deb730ae9800bed84d5375d1f3529e5153ec5ddc3b4f" => :el_capitan
    sha256 "d61ea6c2465cd12faad9aa7c3cdd22e16b51e1182dd554f294d17038ea23d349" => :yosemite
  end

  depends_on :postgresql

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end
