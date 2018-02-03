class Ifuse < Formula
  desc "FUSE module for iPhone and iPod Touch devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/1.1.3.tar.gz"
  sha256 "9b63afa6f2182da9e8c04b9e5a25c509f16f96f5439a271413956ecb67143089"
  head "https://cgit.sukimashita.com/ifuse.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "64dd6106542d5cb35987e0d8ce4ac5f8213b0355eadb81eada715635200681a1" => :high_sierra
    sha256 "ceb08953b9bdc717205c3f931599e4ddb45004c87111132abe1fbca9cebff4bd" => :sierra
    sha256 "306e0f9ffc97245e4792ef95a3f5a7278ea99a4719755d7c198714b2f99ad0f3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
