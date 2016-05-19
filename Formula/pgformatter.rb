class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v1.5.tar.gz"
  sha256 "ab57195a1489ed4daf2356642d5b74885f497e39b94f5edc39c2488755261d03"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f76cde297cb1ce4b4eef407508dd4bb974ad42162b33ae683e93a3145e6390e1" => :el_capitan
    sha256 "08a409874c3adb39bfba7f7bbf47a95315bb16212e7ff88ea0dd03e33a007ba1" => :yosemite
    sha256 "ecaf6a82abcaeb537faeb54b307db969eac733b0459403ea2aab9d0a4e907634" => :mavericks
  end

  def install
    # Fix path to Perl modules. Per default, the script expects to
    # find them in a lib directory beneath it's own path.
    inreplace "pg_format", "$FindBin::Bin/lib", libexec

    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    bin.install "blib/script/pg_format"
    libexec.install "blib/lib/pgFormatter"
    man1.install "blib/man1/pg_format.1"
    man3.install "blib/man3/pgFormatter::Beautify.3pm"
    man3.install "blib/man3/pgFormatter::CGI.3pm"
    man3.install "blib/man3/pgFormatter::CLI.3pm"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
