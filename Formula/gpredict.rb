class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "http://gpredict.oz9aec.net/"
  url "https://github.com/csete/gpredict/releases/download/v2.2.1/gpredict-2.2.1.tar.bz2"
  sha256 "e759c4bae0b17b202a7c0f8281ff016f819b502780d3e77b46fe8767e7498e43"
  revision 2

  bottle do
    rebuild 1
    sha256 "229cd3791dcd48b993f3994956d52466bbaa637d2f40f34f90411b5b59856f32" => :catalina
    sha256 "8d994ed2c6ff6f56c7bae8e79ac832443ee822402718d4a1a59d3feaf22b559a" => :mojave
    sha256 "5b1be9eece92c9d8dc4edf8595643f963e7239f23c937956091e668c3e06a63d" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"

  uses_from_macos "curl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "real-time", shell_output("#{bin}/gpredict -h")
  end
end
