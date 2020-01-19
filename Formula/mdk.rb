class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftp.gnu.org/gnu/mdk/v1.2.10/mdk-1.2.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/mdk/v1.2.10/mdk-1.2.10.tar.gz"
  sha256 "b0f4323a607a3346769499b00fdd6d4748af5a61dd8a24511867ef5d96c08ce7"
  revision 2

  bottle do
    sha256 "da78761cbf4d8c4699e68fbca096e26d4ceb81994a123a76ccee122de11e5f9f" => :catalina
    sha256 "bfe5df6cc1d7b0f0d6afab91c269ecef6ce00201aa6818e8de4fea9bd4c3a06e" => :mojave
    sha256 "dfc235cf424f6319cc87d21d6c3cd5e81402e6754c8e7a4971aff25b5b731ca3" => :high_sierra
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
