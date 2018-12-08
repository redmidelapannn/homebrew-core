class Sz81 < Formula
  desc "ZX80/81 emulator"
  homepage "https://sz81.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sz81/sz81/2.1.7/sz81-2.1.7-source.tar.gz"
  sha256 "4ad530435e37c2cf7261155ec43f1fc9922e00d481cc901b4273f970754144e1"
  head "https://svn.code.sf.net/p/sz81/code/sz81"

  bottle do
    rebuild 1
    sha256 "411faa3977506e3eb5656b57b61d93b8010567d25f499c5536fdec6b468b5a0e" => :mojave
    sha256 "9702256a769b45a100d2c301e0add713eb910c8be4a8c06d07bc44383b39d38b" => :high_sierra
    sha256 "0c234aba8025b5ab0596a19a42db854b59bb4c323528b0e8bedea9585ff55f16" => :sierra
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
