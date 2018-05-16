class Yafc < Formula
  desc "Command-line FTP client"
  homepage "https://github.com/sebastinas/yafc"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  revision 1

  bottle do
    rebuild 1
    sha256 "9403864494c0101dcdfede0d79a2b157826465a7ee32469c5e676ebeab483991" => :high_sierra
    sha256 "f7c6f59a2bd28a4151c0090ac7d4b720d038b4287ff9a44510bb43736da8f529" => :sierra
    sha256 "bf31ac04413d154d2337d2957609c92e53f066a4205582d8682bdbdc361d58d1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "libssh" => :recommended

  def install
    args = %W[
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]
    args << "--without-ssh" if build.without? "libssh"

    system "./configure", *args
    system "make", "install"
  end

  test do
    download_file = testpath/"512KB.zip"
    expected_checksum = Checksum.new("sha256", "07854d2fef297a06ba81685e660c332de36d5d18d546927d30daad6d7fda1541")
    output = pipe_output("#{bin}/yafc -W #{testpath} -a ftp://speedtest.tele2.net/", "get #{download_file.basename}", 0)
    assert_match version.to_s, output
    download_file.verify_checksum expected_checksum
  end
end
