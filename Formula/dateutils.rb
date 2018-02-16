class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.4.2.tar.xz"
  mirror "https://github.com/hroptatyr/dateutils/releases/download/v0.4.2/dateutils-0.4.2.tar.xz"
  sha256 "ecdae892584098ee9d8f5b14bd555fd63e09d1199cb75aac6b02f09c7e2eb46b"

  bottle do
    rebuild 1
    sha256 "009bec66e0a7df612017c0bcf3470f2cd62430807d297ec889a380005ac7bf1f" => :high_sierra
    sha256 "43045ceb3ccc663f47c3b5036854aed58986a73dd3a15f79263f740b239bbb42" => :sierra
    sha256 "61666913166b58501342ebc64784cd483c7d701e7fb4cbf44748c0648fd05022" => :el_capitan
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2012-03-01-00", shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
  end
end
