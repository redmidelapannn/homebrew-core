class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/archive/v2.17.2.tar.gz"
  sha256 "154249d9a76c8ef17c497923fb1204ffe85c9cc86059b7bca37524512c458499"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "54a3893af9f4b997d1c6d18abf065e2276b557412442e406def49b1d3c99d4d4" => :mojave
    sha256 "a24460dff7c5e0ce44f34edef6fd117af7a2a866f0996561620d68b60135ba0c" => :high_sierra
    sha256 "acadae071fcd06beeb0d5d256522cd79eb71db926e0d80c842e97d875e1e6ff9" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    # Fixes the macOS build by esuring some _POSIX_C_SOURCE
    # features are available:
    # https://github.com/axel-download-accelerator/axel/pull/196
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
