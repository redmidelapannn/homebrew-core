class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/wdiff/wdiff-1.2.2.tar.gz"
  sha256 "34ff698c870c87e6e47a838eeaaae729fa73349139fc8db12211d2a22b78af6b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ab6e0fa8fb7b69667ea7d6976925b717d3ba110110293e395913144ac95330ab" => :mojave
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
