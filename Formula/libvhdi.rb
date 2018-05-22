class Libvhdi < Formula
  desc "Library and tools to access the Virtual Hard Disk (VHD) image format"
  homepage "https://github.com/libyal/libvhdi"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libv/libvhdi/libvhdi_20170223.orig.tar.gz"
  version "20170223"
  sha256 "5a9fedaab51a14a92320cd672a48a0fa0b014b975d5dcea5d4e944b32bf1498d"

  bottle do
    cellar :any
    sha256 "9dffa8d6630143c4dcb652dc4de0aa10dbd1c2987c489f113bdafbd830dc1681" => :high_sierra
    sha256 "3c4ae0625aad7b499cb548f233f8fff77ca1ee3f58c841707b1ba90c23309f71" => :sierra
    sha256 "13cc6ef577743f96c02d2ec4b1de96da5e40c6c6f0018748f13d1f9b76d63970" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :osxfuse => :optional

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vhdiinfo -V")
  end
end
