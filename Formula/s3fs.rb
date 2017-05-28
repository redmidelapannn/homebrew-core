class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse.git",
      :revision => "620f6ec61627d9cec812013ba79dc7d724b45914"
  version "1.82.1"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    cellar :any
    sha256 "528c1c0e81a448bfc5eea1a81abe7f62d3522ff5c703ac9608f0ec473f5e9528" => :sierra
    sha256 "0d623161bc448159d9cdf97c806961cc9aa3e4103afbbaa683acbf69ea49cd36" => :el_capitan
    sha256 "0fe15d89248f4496f53c989777274bdaa8ba8fdead62353298fa284d8fafd9e1" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnutls"
  depends_on "nettle"
  depends_on "libgcrypt"

  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--with-gnutls", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Be aware that s3fs has some caveats concerning S3 "directories"
    that have been created by other tools. See the following issue for
    details:

      https://code.google.com/p/s3fs/issues/detail?id=73
    EOS
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end
