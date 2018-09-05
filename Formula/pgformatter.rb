class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v3.0.tar.gz"
  sha256 "8cf2452d0e4a6448e86b80e9a0dbc9252729544150f3141d14192e33bc86fedb"
  head "https://github.com/darold/pgFormatter.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b74d2dfed6edcb70d399d6d5589dc2acfd1e911736a849cf48b321907e7e7e67" => :mojave
    sha256 "11757f42eff47c922d5846bddf282d533792fc5f9425c5f93a9aad12af7ec577" => :high_sierra
    sha256 "11757f42eff47c922d5846bddf282d533792fc5f9425c5f93a9aad12af7ec577" => :sierra
    sha256 "11757f42eff47c922d5846bddf282d533792fc5f9425c5f93a9aad12af7ec577" => :el_capitan
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    prefix.install (buildpath/"usr/local").children
    (libexec/"lib").install "blib/lib/pgFormatter"
    libexec.install bin/"pg_format"
    bin.install_symlink libexec/"pg_format"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
