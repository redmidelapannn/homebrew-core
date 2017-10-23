class GnuCobol < Formula
  desc "Implements much of the COBOL 85 and COBOL 2002 standards"
  homepage "http://www.opencobol.org/"
#  revision 5

  stable do
    url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/2.2/gnucobol-2.2.tar.gz"
    sha256 "925838decd65864b2aa3a4bf1385ce4bc708b942e05e8406945a730d7aab32cb"

    fails_with :clang do
      cause <<~EOS
        Building with Clang configures GNU-COBOL to use Clang as its compiler,
        which causes subsequent GNU-COBOL-based builds to fail.
      EOS
    end
  end


  bottle do
    sha256 "4fc583c3165838fb1e777923650cdb2ac44da108f29dc2b12b230a379346f304" => :high_sierra
    sha256 "557fcf502790e96261243ae1765c141dcf0c44931211f9f7d16e4cc41ea3e553" => :sierra
    sha256 "580a85cd9ee636a0b84b46c4dea7bf279629faf2acb3f570a16cedcf977cb01b" => :el_capitan
  end

  def version_1_1 # do
    version "1.1.0"
    url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/1.1/gnu-cobol-1.1.tar.gz"
    sha256 "5cd6c99b2b1c82fd0c8fffbb350aaf255d484cde43cf5d9b92de1379343b3d7e"

    fails_with :clang do
      cause <<-EOS.undent
        Building with Clang configures GNU-COBOL to use Clang as its compiler,
        which causes subsequent GNU-COBOL-based builds to fail.
      EOS
    end
  end

  def version_2_0 # do
    version "2.0_rc2"
    url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/2.0/gnu-cobol-2.0_rc-2.tar.gz"
    sha256 "f21f5d8c27d8c63805704ba701f1df530e3e4933aa0798fffee6d071adac47de"
  end

  def version_2_2 # do
    version "2.2"
    url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/2.2/gnucobol-2.2.tar.gz"
    sha256 "925838decd65864b2aa3a4bf1385ce4bc708b942e05e8406945a730d7aab32cb"
  end


  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "gcc"

  conflicts_with "open-cobol",
    :because => "both install `cob-config`, `cobc` and `cobcrun` binaries"

  def install
    # both environment variables are needed to be set
    # the cobol compiler takes these variables for calling cc during its run
    # if the paths to gmp and bdb are not provided, the run of cobc fails
    gmp = Formula["gmp"]
    bdb = Formula["berkeley-db"]
    ENV.append "CPPFLAGS", "-I#{gmp.opt_include} -I#{bdb.opt_include}"
    ENV.append "LDFLAGS", "-L#{gmp.opt_lib} -L#{bdb.opt_lib}"

    args = ["--prefix=#{prefix}", "--infodir=#{info}"]
    args << "--with-libiconv-prefix=/usr"
    args << "--with-libintl-prefix=/usr"

    if build.stable?
      system "aclocal"

      # fix referencing of libintl and libiconv for ld
      # bug report can be found here: https://sourceforge.net/p/open-cobol/bugs/93/
      inreplace "configure", "-R$found_dir", "-L$found_dir"

      args << "--with-cc=#{ENV.cc}"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"hello.cob").write <<-EOS
       IDENTIFICATION DIVISION.
       PROGRAM-ID. hello.
       PROCEDURE DIVISION.
       DISPLAY "Hello World!".
       STOP RUN.
    EOS
    system "#{bin}/cobc", "-x", testpath/"hello.cob"
    system testpath/"hello"
  end
end
