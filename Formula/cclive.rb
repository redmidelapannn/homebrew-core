class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "https://cclive.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz"
  sha256 "586a120faddcfa16f5bb058b5c901f1659336c6fc85a0d3f1538882a44ee10e1"
  revision 3

  bottle do
    cellar :any
    sha256 "01a6a9d427ddfa8e08451f19872eb341a771346d886d4739490ca03b5e4519fe" => :mojave
    sha256 "bea921eda3695efea705a472db7851d2ce3b0578e35f0385897eaa1e9e16e72e" => :high_sierra
    sha256 "8856be145c903d54f1211a3e14b1bb19ad78aedbaf7041658c43cef23578698a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "pcre"
  depends_on "quvi"

  conflicts_with "clozure-cl", :because => "both install a ccl binary"

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
