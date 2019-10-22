class Gocr < Formula
  desc "Optical Character Recognition (OCR), converts images back to text"
  homepage "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/"
  url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/gocr-0.52.tar.gz"
  sha256 "df906463105f5f4273becc2404570f187d4ea52bd5769d33a7a8661a747b8686"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0a51693c84f5016f782356f64b8bfbcdca034a38c4bbf3f132cd0c253602c089" => :catalina
    sha256 "359f3fd97d230cdb975fd2d51f64a149a39b2c76f616a70812ec44f8ad3b74a8" => :mojave
    sha256 "41c36539c2be5820ebc453197a6f0c740a6d1c75d36bdf6c195f4ff7463fe40c" => :high_sierra
  end

  depends_on "jpeg"
  depends_on "netpbm"

  # Edit makefile to install libs per developer documentation
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gocr/0.50.patch"
    sha256 "0ed4338c3233a8d1d165f687d6cbe6eee3d393628cdf711a4f8f06b5edc7c4dc"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! "mandir", "/share/man"
    end

    system "make", "libs"
    system "make", "install"
  end

  test do
    system "#{bin}/gocr", "--help"
  end
end
