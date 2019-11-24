class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.13.1.tar.gz"
  sha256 "47f4bc645c1b6ee15068d406a90bb38aec816354e140291ccb01e536f2cdaf5f"

  bottle do
    cellar :any
    rebuild 2
    sha256 "199cabff23c155ffd5af243abd07ce82a0881c1dd54a582b1313999a807d7ecf" => :catalina
    sha256 "962cd05ea1d74cbc8fac5141b9e22aee7524ecfd8778aa0fad5b7f95816c3659" => :mojave
    sha256 "e566f3748049d623fde9d0f276990945aa51c0aee3144bbf511a080465ffac55" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  uses_from_macos "libxml2"

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
