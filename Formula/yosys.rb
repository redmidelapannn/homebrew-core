class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.9.tar.gz"
  sha256 "f2e31371f9cf1b36cb4f57b23fd6eb849adc7d935dcf49f3c905aa5136382c2f"
  revision 1
  head "https://github.com/YosysHQ/yosys.git"

  bottle do
    sha256 "fd0f2c2939b1ac37c7a356ac1518c71a036b41d494bac9534293940a830b3636" => :catalina
    sha256 "84481ae34413d5d678e967575cdacb1a346aca98da44c02102eff0dfee4cd485" => :mojave
    sha256 "647b6ed130abb6d0e00a9f8a0195531c05d4130bfb5aa814370fecac8f760759" => :high_sierra
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
