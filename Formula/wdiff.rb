class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "https://ftpmirror.gnu.org/wdiff/wdiff-1.2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  sha256 "34ff698c870c87e6e47a838eeaaae729fa73349139fc8db12211d2a22b78af6b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2e3e40ebdb98e11d783fd5e8e9f5c7c553ae06c739b47a4cf3aa3c4c9483cdf2" => :el_capitan
    sha256 "90e57be5c2d854f3467e0f6b7acf2221f6eb974da6e2f0e907b5169e138b89c5" => :yosemite
    sha256 "16d6ca4fbb4644722cc74097e7fa5cd5648a0d6f112b091f881e66ccb7abfdf9" => :mavericks
  end

  depends_on "gettext" => :optional

  conflicts_with "montage", :because => "Both install an mdiff executable"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make", "install"
  end

  test do
    a = testpath/"a.txt"
    a.write "The missing package manager for OS X"

    b = testpath/"b.txt"
    b.write "The package manager for OS X"

    output = shell_output("#{bin}/wdiff #{a} #{b}", 1)
    assert_equal "The [-missing-] package manager for OS X", output
  end
end
