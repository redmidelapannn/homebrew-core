class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/cliffordwolf/yosys/archive/yosys-0.8.tar.gz"
  sha256 "07760fe732003585b26d97f9e02bcddf242ff7fc33dbd415446ac7c70e85c66f"
  revision 1
  head "https://github.com/cliffordwolf/yosys.git"

  bottle do
    rebuild 1
    sha256 "e26b448102812d4a4b8edde821df36b51f59fd2da3c59fef2a5182cdad857a48" => :mojave
    sha256 "9e1ffe12a6bfbcd698660f75bd9fc07c1c00a002852e98f627fcbd50b61a5fb7" => :high_sierra
    sha256 "b111ebacfa1a49c14146437d0ce9a3d92f0629487abc4251df5dc20560caa082" => :sierra
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
