class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/babel/"
  url "http://www.pps.jussieu.fr/~jch/software/files/babeld-1.9.1.tar.gz"
  sha256 "1e1b3c01dd929177bc8d027aff1494da75e1e567e1f60df3bb45a78d5f1ca0b4"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdbc9943a518f44d77257c332c17adcfdb3eff2d8c31721a0122151d7e285fb6" => :catalina
    sha256 "fcfde958891e46098952b6792e76fbd90c4a5ebd175d6de1afd0c3b1b4fadf7e" => :mojave
    sha256 "169106aab8044d9fec78103de1a58faab386fbc580f2f7644b5622ff2f244fd0" => :high_sierra
  end

  def install
    system "make", "LDLIBS=''"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    expected = <<~EOS
      Couldn't tweak forwarding knob.: Operation not permitted
      kernel_setup failed.
    EOS
    assert_equal expected, (testpath/"test.log").read
  end
end
