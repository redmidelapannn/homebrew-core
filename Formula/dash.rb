class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.10.2.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/dash-0.5.10.2.tar.gz"
  sha256 "3c663919dc5c66ec991da14c7cf7e0be8ad00f3db73986a987c118862b5f6071"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "483fb98fd5a8d0c9204369d32caed689af8c17c26fd07ed2b9cc1abfa561c4cc" => :high_sierra
    sha256 "d36f0febf3f42e4f428628f3bda800433c46c3198659f407a13e62c9f4525c92" => :sierra
    sha256 "93d4924e5fdc1cb8e2fcab8ce01577a567e70d68bf6f459d9f3355d58d52fc16" => :el_capitan
  end

  head do
    url "https://git.kernel.org/pub/scm/utils/dash/dash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking",
                          "--enable-fnmatch"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
