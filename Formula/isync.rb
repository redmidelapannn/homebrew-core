class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.2.1/isync-1.2.1.tar.gz"
  sha256 "e716de28c9a08e624a035caae3902fcf3b511553be5d61517a133e03aa3532ae"

  bottle do
    cellar :any
    rebuild 2
    sha256 "e51f32f5bbb098fb48ade07621e53d42ffcba879209e50690be9acf41259ce7b" => :sierra
    sha256 "91e9be1cfd3caa7827042ca7683ee76995725fffef318f9f488fec5f81047dcb" => :el_capitan
    sha256 "e93c1ff1001a054260df3f44f62489313474c40b540d7552e79bd461f07b567e" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/isync/isync.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"
  depends_on "berkeley-db" => :optional

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]
    args << "ac_cv_berkdb4=no" if build.without? "berkeley-db"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"get-cert", "duckduckgo.com:443"
  end
end
