class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "https://cclive.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz"
  sha256 "586a120faddcfa16f5bb058b5c901f1659336c6fc85a0d3f1538882a44ee10e1"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "04ae61b1cb62cac0489841ebfa657864cc25d11217c3d2d0c9d053e6dcf7754a" => :high_sierra
    sha256 "468cb2a6dc4cd5b147d7855e2177292e9ec4189ecb711d22f687e666aa095b9a" => :sierra
    sha256 "a437cb65395d72904eb8772569cfb06ecf5d98587951f673f7bd050910ed2740" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "quvi"
  depends_on "boost"
  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    url = "https://youtu.be/VaVZL7F6vqU"
    output = shell_output("#{bin}/cclive --no-download #{url} 2>&1")
    assert_match "Martin Luther King Jr Day", output
  end
end
