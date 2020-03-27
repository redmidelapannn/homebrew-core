class Yosys < Formula
  include Hardware
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.9.tar.gz"
  sha256 "f2e31371f9cf1b36cb4f57b23fd6eb849adc7d935dcf49f3c905aa5136382c2f"
  head "https://github.com/YosysHQ/yosys.git"

  bottle do
    rebuild 1
    sha256 "15bb20dcf753111cea60c55612bf5d945a117e351a8167ac51bbfa4cb66d8a4a" => :catalina
    sha256 "f98d5216cab36c4e72a925ab264a6c356dd80f849c3bbdbe8d2531caba74b0ae" => :mojave
    sha256 "dea6bb68a42b42b047b8336e829799b2f32f9fc302fac47d089c0df1d2539d23" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0", "-j#{CPU.cores}"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
