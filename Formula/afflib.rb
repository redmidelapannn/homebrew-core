class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.16.tar.gz"
  sha256 "9c0522941a24a3aafa027e510c6add5ca9f4defd2d859da3e0b536ad11b6bf72"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9cdfaca41602e4d676aff36f99ab63475972ce9feb31ffef81afa91635578f6b" => :high_sierra
    sha256 "a400e8c8ec9d87b178f058107a5da16e86775dd8b7ffc937e106824c6ca13c57" => :sierra
    sha256 "c38866f8bb14235a434cdfdc6a57600aba7116e78ff7cd62dc82c019330ecfd7" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python@2"
  depends_on :osxfuse => :optional

  def install
    args = ["--enable-s3", "--enable-python"]

    if build.with? "osxfuse"
      ENV.append "CPPFLAGS", "-I/usr/local/include/osxfuse"
      ENV.append "LDFLAGS", "-L/usr/local/lib"
      args << "--enable-fuse"
    else
      args << "--disable-fuse"
    end

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
