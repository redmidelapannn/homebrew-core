class Par < Formula
  desc "Paragraph reflow for email"
  homepage "http://www.nicemice.net/par/"
  url "http://www.nicemice.net/par/Par152.tar.gz"
  mirror "http://ftp.netbsd.org/pub/pkgsrc/distfiles/Par152.tar.gz"
  version "1.52"
  sha256 "33dcdae905f4b4267b4dc1f3efb032d79705ca8d2122e17efdecfd8162067082"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "5c02e5de8ac8551ab6009af86810ced398b5faa209c34c5ab663916846ef41c5" => :catalina
    sha256 "8bc36e36e8afba111a221aa11be57f8f37f21f1e62c8329298a87852088a5b04" => :mojave
    sha256 "4761c441894059e11dbf98e63a1dbf5b67554ceee073e92c16ec5a404c619fd1" => :high_sierra
  end

  conflicts_with "rancid", :because => "both install `par` binaries"

  # Patch to add support for multibyte charsets (like UTF-8), plus Debian
  # packaging.
  patch do
    url "http://sysmic.org/dl/par/par-1.52-i18n.4.patch"
    sha256 "2ab2d6039529aa3e7aff4920c1630003b8c97c722c8adc6d7762aa34e795861e"
  end

  def install
    system "make", "-f", "protoMakefile"
    bin.install "par"
    man1.install gzip("par.1")
  end

  test do
    expected = "homebrew\nhomebrew\n"
    assert_equal expected, pipe_output("#{bin}/par 10gqr", "homebrew homebrew")
  end
end
