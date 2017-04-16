class Cmatrix < Formula
  desc "Console Matrix"
  homepage "https://www.asty.org/cmatrix/"
  url "https://www.asty.org/cmatrix/dist/cmatrix-1.2a.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cmatrix/cmatrix_1.2a.orig.tar.gz"
  sha256 "1fa6e6caea254b6fe70a492efddc1b40ad7ccb950a5adfd80df75b640577064c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5efbc9cae45cda0159aa5a2238a5a5a3fea366a078d51447ee1d895cd93ef9dd" => :sierra
    sha256 "818f6c59941021ee8d057e0b6198a2be6ebff910b8d6eea4f685a15f4772d996" => :el_capitan
    sha256 "5166835d54f9af2fc432847ea10260cddb206efa62572962be3ab582480b19f5" => :yosemite
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
