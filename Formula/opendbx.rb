class Opendbx < Formula
  desc "Lightweight but extensible database access library in C"
  homepage "https://linuxnetworks.de/doc/index.php/OpenDBX"
  url "https://linuxnetworks.de/opendbx/download/opendbx-1.4.6.tar.gz"
  sha256 "2246a03812c7d90f10194ad01c2213a7646e383000a800277c6fb8d2bf81497c"

  bottle do
    revision 1
    sha256 "02175c6abd2c90f9592c88e9772263815df342211f87a30fd6e8fcb4db2de1c7" => :el_capitan
    sha256 "fab6f466885c460fff5d0930d1ae2c5f2b1bb596f20f109391d583c4bee842c2" => :yosemite
    sha256 "8dc5a53a38a05b6c5f2722d5df162854d83df4341b308dc0ad3692122a1d1bc4" => :mavericks
  end

  depends_on "sqlite"

  def install
    # Reported upstream: http://bugs.linuxnetworks.de/index.php?do=details&id=40
    inreplace "utils/Makefile.in", "$(LIBSUFFIX)", ".dylib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-backends=sqlite3"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"test.sql"
    testfile.write <<-EOS.undent
      create table t(x);
      insert into t values("Hello");
      .header
      select * from t;
      .quit
    EOS

    assert_match /"Hello"/,
      shell_output("#{bin}/odbx-sql odbx-sql -h ./ -d test.sqlite3 -b sqlite3 < #{testpath}/test.sql")
  end
end
