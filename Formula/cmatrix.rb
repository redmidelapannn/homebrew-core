class Cmatrix < Formula
  desc "Console Matrix"
  homepage "https://www.asty.org/cmatrix/"
  url "https://www.asty.org/cmatrix/dist/cmatrix-1.2a.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cmatrix/cmatrix_1.2a.orig.tar.gz"
  sha256 "1fa6e6caea254b6fe70a492efddc1b40ad7ccb950a5adfd80df75b640577064c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "260e3007198dc77f288cb0712dab06bb08e23920469fb26db9e9dddda4001e83" => :mojave
    sha256 "ef44453034c22fd6a58d4920895baca33cb81f6b11adde657f312db650dd61cc" => :high_sierra
    sha256 "f0ec1fde291e30999de5d7fefcc1976c6249f5bae0e08f2842082634c60020bb" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/cmatrix", "-V"
  end
end
