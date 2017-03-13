class GnuChess < Formula
  desc "GNU Chess"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftpmirror.gnu.org/chess/gnuchess-6.2.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.4.tar.gz"
  sha256 "3c425c0264f253fc5cc2ba969abe667d77703c728770bd4b23c456cbe5e082ef"

  bottle do
    rebuild 1
    sha256 "fef76b71705cb583a947e68e2f96a15c844b1299448725487de2fee23c20a877" => :sierra
    sha256 "e16011c3b73eb5e13eab072b9c7c11fdbf8f555f10aa7da81602097c521bde05" => :el_capitan
    sha256 "3065ae2f49bdf9200e5194b8a016510d1a0b632392f89586809f5375e00a2592" => :yosemite
  end

  head do
    url "https://svn.savannah.gnu.org/svn/chess/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "gettext"
  end

  option "with-book", "Download the opening book (~25MB)"

  resource "book" do
    url "https://ftpmirror.gnu.org/chess/book_1.02.pgn.gz"
    sha256 "deac77edb061a59249a19deb03da349cae051e52527a6cb5af808d9398d32d44"
  end

  def install
    if build.head?
      system "autoreconf", "--install"
      chmod 0755, "install-sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build.with? "book"
      resource("book").stage do
        doc.install "book_1.02.pgn"
      end
    end
  end

  if build.with? "book"
    def caveats; <<-EOS.undent
      This formula also downloads the additional opening book.  The
      opening book is a PGN file located in #{doc} that can be added
      using gnuchess commands.
    EOS
    end
  end

  test do
    assert_equal "GNU Chess #{version}", shell_output("#{bin}/gnuchess --version").chomp
  end
end
