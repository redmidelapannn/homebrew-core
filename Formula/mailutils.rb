class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.4.tar.gz"
  sha256 "a3e83b1450222ffdbc7fa42e7171d530fcd568b6871158a489d86840ae130df7"

  bottle do
    rebuild 1
    sha256 "83b2007af789540f0eb8d3ad8be7e74d8bffd73b28e513cd6519d7423148058b" => :high_sierra
    sha256 "339d8842900794fbec1fdf9a8f4c83fc0f3e5bb86e2e40bdb0f9021169bd004f" => :sierra
    sha256 "9b1cbea4b5c07b52d6cdfa6f2c5a6feccf6f829fdfd626ffb176a98e47ebfda8" => :el_capitan
  end

  depends_on "libtool" => :run
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
