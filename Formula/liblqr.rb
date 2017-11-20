class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "https://liblqr.wikidot.com/"
  url "https://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.2.tar.bz2"
  version "0.4.2"
  sha256 "173a822efd207d72cda7d7f4e951c5000f31b10209366ff7f0f5972f7f9ff137"

  head "http://repo.or.cz/liblqr.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "47dae79a2664d07dcb055b9d0f3f6409317258f9607a17706cc8a1224a1a94b5" => :high_sierra
    sha256 "e3d689665516875f80a32c4cc4811373a63653c3cccc0221f3ecbe0f86b16039" => :sierra
    sha256 "44613d77c4fd76afe5539dd0432a4a67c0f89e2c8089349443135ed74e253764" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
