class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "https://github.com/steveicarus/iverilog/archive/v10_3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/iverilog/iverilog_10.3.orig.tar.gz"
  sha256 "4b884261645a73b37467242d6ae69264fdde2e7c4c15b245d902531efaaeb234"
  head "https://github.com/steveicarus/iverilog.git"

  bottle do
    rebuild 1
    sha256 "e6faa3a78d7adf3b4d4a8e4f36e604c2153911fc54358cdd0d9702981ddc5563" => :catalina
    sha256 "845d6543f45630bb13be6697b63b74c6b682c8a34e91b97c666471507f72f7ae" => :mojave
    sha256 "c2b4b4195510eae38174bca4bd9deb5c8826347c611ab9ce0cd68ce6989e3eb0" => :high_sierra
  end

  depends_on "autoconf" => :build
  # parser is subtly broken when processed with an old version of bison
  depends_on "bison" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    # https://github.com/steveicarus/iverilog/issues/85
    ENV.deparallelize
    system "make", "install", "BISON=#{Formula["bison"].opt_bin}/bison"
  end

  test do
    (testpath/"test.v").write <<~EOS
      module main;
        initial
          begin
            $display("Boop");
            $finish;
          end
      endmodule
    EOS
    system bin/"iverilog", "-otest", "test.v"
    assert_equal "Boop", shell_output("./test").chomp

    # test syntax errors do not cause segfaults
    (testpath/"error.v").write "error;"
    assert_equal "-:1: error: variable declarations must be contained within a module.",
      shell_output("#{bin}/iverilog error.v 2>&1", 1).chomp
  end
end
