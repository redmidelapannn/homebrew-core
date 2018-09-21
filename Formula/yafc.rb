class Yafc < Formula
  desc "Command-line FTP client"
  homepage "https://github.com/sebastinas/yafc"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  revision 2

  bottle do
    rebuild 1
    sha256 "4a11b2e710b024c2af408b4b03b0ac2cb8586412cc44d8b8aff3aabf06ac6cb6" => :mojave
    sha256 "a4ab9fc22be686fa04a3aea7db8381aaea1ddf8a9cc37a03f5ef544796f16279" => :high_sierra
    sha256 "cbd18b883b97353001f12fc85fcef5f50625e22701feb3c5d6d398d010c29f6b" => :sierra
    sha256 "3a7e61b4902d46a2ee2f8c9c46c9c63b032dc2ea510a16d5f1bcb040800bde08" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

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
