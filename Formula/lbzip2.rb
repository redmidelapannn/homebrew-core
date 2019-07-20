class Lbzip2 < Formula
  desc "Parallel bzip2 utility"
  homepage "https://github.com/kjn/lbzip2"
  url "https://web.archive.org/web/20170304050514/archive.lbzip2.org/lbzip2-2.5.tar.bz2"
  mirror "https://fossies.org/linux/privat/lbzip2-2.5.tar.bz2"
  sha256 "eec4ff08376090494fa3710649b73e5412c3687b4b9b758c93f73aa7be27555b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a711b0927f78bd14934f0174b5d027818f87639b949e63edcf65517a90d1485f" => :mojave
    sha256 "87d72b48c4d6bf9287b71a8d8bcea28e758051320c2f3f1f446c7580622646ce" => :high_sierra
    sha256 "3d543faba0a62d63005fea8352a17b92248a5b53785871baf8ab15391d42d142" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    touch "fish"
    system "#{bin}/lbzip2", "fish"
    system "#{bin}/lbunzip2", "fish.bz2"
  end
end
