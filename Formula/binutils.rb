class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.33.1.tar.gz"
  sha256 "98aba5f673280451a09df3a8d8eddb3aa0c505ac183f1e2f9d00c67aa04c6f7d"

  bottle do
    sha256 "cc0be2b4198597a513413e2957423e6db06b183dfef802f4fa1a493a42388ddb" => :catalina
    sha256 "101c47b5ba0dd14c33ae6252f0f732f2c9e3db9bb5bf03c880533b62e9f18dc2" => :mojave
    sha256 "b82cf83f50a4822652022612c4f51052a56741e281ee509c8f18e1485b29cdaa" => :high_sierra
    sha256 "7fabb9b6e95bbc156469a765189e153917adb9b8fbdc24a7662f42b4995ba825" => :sierra
  end

  uses_from_macos "zlib"

  keg_only :provided_by_macos,
           "because Apple provides the same tools and binutils is poorly supported on macOS"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
    Dir["#{bin}/*"].each do |f|
      bin.install_symlink f => "g" + File.basename(f)
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
