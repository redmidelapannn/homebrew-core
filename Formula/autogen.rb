class Autogen < Formula
  desc "Automated text file generator"
  homepage "http://autogen.sourceforge.net"
  url "https://ftpmirror.gnu.org/autogen/autogen-5.18.7.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autogen/autogen-5.18.7.tar.xz"
  sha256 "a7a580a5e18931cb341b255cec2fee2dfd81bea5ddbf0d8ad722703e19aaa405"

  bottle do
    revision 1
    sha256 "0606bddf5139289d4c8e049fa2cad60e2ed953b98e76460dfadb4038b582ace1" => :el_capitan
    sha256 "cb70592e06a6807a8a2eb5796d89670c67ecbece03c3179167adc4240eab7fda" => :yosemite
    sha256 "c0a72bd7ff4d553a796f498be2dac59c2f98925fac5346fbe4b912b19a28f93d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end
