class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "ftp://icarus.com/pub/eda/verilog/v10/verilog-10.2.tar.gz"
  sha256 "96dedbddb12d375edb45a144a926a3ba1e3e138d6598b18e7d79f2ae6de9e500"

  bottle do
    rebuild 1
    sha256 "123cd8a389ff54005741cf0d38f32ab44834d2081504291766a0a26caa7537c8" => :high_sierra
    sha256 "e60b1c62868e74079f71921c9596482135c06572024a1a4710b406f92890658a" => :sierra
    sha256 "72b90a371f0db8564de90d6e698efebd07203ffeee51b137ae95baeccf520635" => :el_capitan
  end

  head do
    url "https://github.com/steveicarus/iverilog.git"
    depends_on "autoconf" => :build
  end

  # parser is subtly broken when processed with an old version of bison
  depends_on "bison" => :build

  def install
    bison = Formula["bison"].bin/"bison"
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # https://github.com/steveicarus/iverilog/issues/85
    ENV.deparallelize
    system "make", "install", "BISON=#{bison}"
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
    assert_equal "-:1: error: variable declarations must be contained within a module.\n",
      shell_output("#{bin}/iverilog error.v 2>&1", 1)
  end
end
