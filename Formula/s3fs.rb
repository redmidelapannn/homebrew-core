class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.85.tar.gz"
  sha256 "c4b48c0aba6565b9531c251d42a6a475a7e845909a3017b61d9c945b15cc008f"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "66cd5d6d27d55e167dcff79395d83576fce889de9cb83b9164b0e7f33a9e49f2" => :mojave
    sha256 "9e831fbce71d1b6d6c2b65d0688bc2210eb126da9d7d9429e4abc00e0b9f2ae1" => :high_sierra
    sha256 "db7e946b4789c264c8e872c4d4654aca775ba9baa34724fe7e7dac153d4a3c04" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "nettle"

  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--with-gnutls", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end
