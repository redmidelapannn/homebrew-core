class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.12.0.tar.gz"
  sha256 "852cf59d682a91974f715f09fa98cab621b740226adcfea7a42360be0f86464f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7258adb5fdd04d2d729f19ae30f5d140ce16de79eaab5c4d7bee1f46a9da584c" => :mojave
    sha256 "ec0838bac4ae7f5a5199aee7ee931c8388c9d265a6b0e0e80800c956d275ee1f" => :high_sierra
    sha256 "6f2e90b0457d886aed2427c2575416c4d89fff6732e1d04975f449f5e780b59e" => :sierra
    sha256 "538088b809264625c7a9ad9020ab0a46ddf2e4a231dd21f2ad261614bcf24539" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    # fuse requires librt, unavailable on OSX
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-fuse
      --without-ntfs-3g
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    # make a directory containing a dummy 1M file
    mkdir("foo")
    system "dd", "if=/dev/random", "of=foo/bar", "bs=1m", "count=1"

    # capture an image
    ENV.append "WIMLIB_IMAGEX_USE_UTF8", "1"
    system "#{bin}/wimcapture", "foo", "bar.wim"
    assert_predicate testpath/"bar.wim", :exist?

    # get info on the image
    system "#{bin}/wiminfo", "bar.wim"
  end
end
