class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftpmirror.gnu.org/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  sha256 "6c265ddd7436925208513b155e7955e5a88c158cddda72c32714ccf5f3e74430"
  revision 1

  bottle do
    rebuild 1
    sha256 "b11a10e1247c326bfa5c06539b74dd81b337b930c8a30583820fae5c0794527c" => :sierra
    sha256 "a133393465c4659c334d178a3674f595c2194180c24f8e6ee7f97f24b52d6310" => :el_capitan
    sha256 "b6a1fe962e0e3385c5a9a4c5eede2fce74a01a4ed57bac21f5e23a55422122ca" => :yosemite
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "libglade"
  depends_on "glib"
  depends_on "flex"
  depends_on "guile"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.mixal").write <<-EOS.undent
      *                                                        (1)
      * hello.mixal: say "hello world" in MIXAL                (2)
      *                                                        (3)
      * label ins    operand     comment                       (4)
      TERM    EQU    19          the MIX console device number (5)
              ORIG   1000        start address                 (6)
      START   OUT    MSG(TERM)   output data at address MSG    (7)
              HLT                halt execution                (8)
      MSG     ALF    "MIXAL"                                   (9)
              ALF    " HELL"                                   (10)
              ALF    "O WOR"                                   (11)
              ALF    "LD"                                      (12)
              END    START       end of the program            (13)
    EOS
    system "#{bin}/mixasm", "hello"
    output = `#{bin}/mixvm -r hello`

    expected = <<-EOS.undent
      Program loaded. Start address: 1000
      Running ...
      MIXAL HELLO WORLDXXX
      ... done
    EOS
    expected = expected.gsub("XXX", " " *53)

    assert_equal expected, output
  end
end
