class Aldo < Formula
  desc "Morse code learning tool released under GPL"
  homepage "https://www.nongnu.org/aldo/"
  url "https://savannah.nongnu.org/download/aldo/aldo-0.7.7.tar.bz2"
  sha256 "f1b8849d09267fff3c1f5122097d90fec261291f51b1e075f37fad8f1b7d9f92"

  bottle do
    cellar :any
    rebuild 2
    sha256 "45e2aa7235800def3e1436ee42d60a312bb2f19d8425e55ca9807cb513aa446a" => :catalina
    sha256 "7bf0cf1e4bf1eabf172b402261c52fb6ac92c780fa5879b2a62f34a1fff29ed1" => :mojave
    sha256 "fae3fb00d5b9c3949a1e6eaf6bd03e1c783a62c981c69901287a7979bc7a9fae" => :high_sierra
  end

  depends_on "libao"

  # Reported upstream:
  # https://savannah.nongnu.org/bugs/index.php?42127
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/aldo/0.7.7.patch"
    sha256 "3b6c6cc067fc690b5af4042a2326cee2b74071966e9e2cd71fab061fde6c4a5d"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Aldo #{version} Main Menu", pipe_output("#{bin}/aldo", "6")
  end
end
