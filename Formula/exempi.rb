class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.5.0.tar.bz2"
  sha256 "dc82fc24c0540a44a63fa4ad21775d24e00e63f1dedd3e2ae6f7aa27583b711b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fdfb3bc001db52520f841aad385cb2e4f06cd985d9ef70242dc6dec5fc6337fa" => :mojave
    sha256 "fdb272956cb6c7a859f8111cb47f974ab27aa28eb7014e52e672f0ca7a60fd05" => :high_sierra
    sha256 "bfacd895c4828c55631a40fa30d9d27810f91e16d19b7e77238beee145ed0627" => :sierra
  end

  depends_on "boost"
  uses_from_macos "expat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
