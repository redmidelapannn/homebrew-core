class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "https://cclive.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz"
  sha256 "586a120faddcfa16f5bb058b5c901f1659336c6fc85a0d3f1538882a44ee10e1"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "8d5126d96d7e1b7aadfb6a07bacb658943e32fc089579612aa0a310357c777b4" => :high_sierra
    sha256 "e961291bb9bbb064b35cd5f594229c6a410397fb3949fe61d92752e8b95051f3" => :sierra
    sha256 "15c1c3a01af87dce2a36be24548c82fc640c1959a02720952105b189b5518f6e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "quvi"
  depends_on "boost"
  depends_on "pcre"

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
