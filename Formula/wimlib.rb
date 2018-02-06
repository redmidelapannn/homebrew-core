class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.12.0.tar.gz"
  sha256 "852cf59d682a91974f715f09fa98cab621b740226adcfea7a42360be0f86464f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f9711e9cf70749652971aed957360e64822c426324a3c00637a70ee46e97b32e" => :high_sierra
    sha256 "913f3c002117a1d6cb5878e1ae93395f779c8de433c0cbba71c47dde1d734b19" => :sierra
    sha256 "ae32c0f09c386fed9d035cd70f50e514932227c4f4b1bdeba017bce6e7c67d69" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "ntfs-3g" => :optional
  depends_on "openssl"

  def install
    # fuse requires librt, unavailable on OSX
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --without-fuse
      --prefix=#{prefix}
    ]

    args << "--without-ntfs-3g" if build.without? "ntfs-3g"

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
