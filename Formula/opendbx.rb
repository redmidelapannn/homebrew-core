class Opendbx < Formula
  desc "Lightweight but extensible database access library in C"
  homepage "https://linuxnetworks.de/doc/index.php/OpenDBX"
  url "https://linuxnetworks.de/opendbx/download/opendbx-1.4.6.tar.gz"
  sha256 "2246a03812c7d90f10194ad01c2213a7646e383000a800277c6fb8d2bf81497c"

  bottle do
    rebuild 1
    sha256 "55a52a5de72a8fd66b7a2058b2b8c63b5716e23c8ffce17cb1e8ab49faa20b98" => :sierra
    sha256 "f4c9fc48b8dd35f5e3f85c63e580dbd22701e22527db4ceacd294e1325369701" => :el_capitan
    sha256 "1b0cd2a97137cfb90d0581cf3b9296c09633c4281c962f110f4f69ce437152bc" => :yosemite
  end

  depends_on "readline"
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
