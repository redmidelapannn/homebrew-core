class Sz81 < Formula
  desc "ZX80/81 emulator"
  homepage "https://sz81.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sz81/sz81/2.1.7/sz81-2.1.7-source.tar.gz"
  sha256 "4ad530435e37c2cf7261155ec43f1fc9922e00d481cc901b4273f970754144e1"
  head "https://svn.code.sf.net/p/sz81/code/sz81"

  bottle do
    rebuild 1
    sha256 "f699eb66bb607efcd78760b147dda78b350d90d3c7eb6a8ee6127bf55ebffaca" => :mojave
    sha256 "c2e9066098921c14aa68944098b09ce74555fb553b532ea2a73f59ed015143cf" => :high_sierra
    sha256 "3b907ac658d1793e0a27bfd72cc487063747c0fd3bc042c567fef4e77e630db0" => :sierra
  end

  depends_on "sdl"

  def install
    args = %W[
      PREFIX=#{prefix}
      BINDIR=#{bin}
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_match /sz81 #{version} -/, shell_output("#{bin}/sz81 -h", 1)
  end
end
