class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "http://xdelta.org"
  url "https://github.com/jmacd/xdelta/archive/v3.1.0.tar.gz"
  sha256 "7515cf5378fca287a57f4e2fee1094aabc79569cfe60d91e06021a8fd7bae29d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "23338bc82166824de8f6d6356977ffd0b5ed2dc5a1283913f2b07fc0a009eab8" => :mojave
    sha256 "6def325ace77308c533df41a5577aa14474394d1f36f17dbc589ab95bf7bd744" => :high_sierra
    sha256 "d7dd0f2bf5c42e03c0d718c6a633d0e4a2193dc29a47f3837156bcc28393cf43" => :sierra
    sha256 "9ae3af4a4e1f9ca00c3ed3ce16aaa7090939a7fad6a741b042b0aabec9fac172" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  def install
    cd "xdelta3" do
      system "autoreconf", "--install"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-liblzma"
      system "make", "install"
    end
  end

  test do
    system bin/"xdelta3", "config"
  end
end
