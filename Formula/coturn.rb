class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.1/turnserver-4.5.1.1.tar.gz"
  sha256 "e020ce90ea0301213451d37099185ff25d93f97fa0f2b48bf21b2946fc3696a4"
  revision 2

  bottle do
    sha256 "ca76d13a2d1ccbd5d9f344cf5bdaaea3e162227e8cd97cd239f49d7a6ea53216" => :mojave
    sha256 "3aadac9d3e8027060bcd0a7f2eff047e0d5f843f5aaf539675ba3111420871a9" => :high_sierra
    sha256 "3d3a6490e53fa52ceeaf5ca313ed3306537151917a354d9a8e6b7948477ad5c9" => :sierra
  end

  depends_on "hiredis"
  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
