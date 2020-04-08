class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftp.gnu.org/gnu/mdk/v1.2.10/mdk-1.2.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/mdk/v1.2.10/mdk-1.2.10.tar.gz"
  sha256 "b0f4323a607a3346769499b00fdd6d4748af5a61dd8a24511867ef5d96c08ce7"
  revision 2

  bottle do
    sha256 "caac7c9439944f897c463be72250547dda2ddfb192ac2a7d347eb06f12784d96" => :catalina
    sha256 "ccf36d885b9322fab17cacec5b8d75c64710372405c0a273e0929d52506e01b7" => :mojave
    sha256 "3a9670923f0eb95a36d6d8865520a24ef9b9f62ac968dc85fca30bbce58ae1bd" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "flex"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "guile"
  depends_on "libglade"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"

    (testpath/"hello.mixal").write <<~EOS
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

    expected = <<~EOS
      Program loaded. Start address: 1000
      Running ...
      MIXAL HELLO WORLDXXX
      ... done
    EOS
    expected = expected.gsub("XXX", " " *53)

    assert_equal expected, output
  end
end
