class Chezscheme < Formula
  desc "Chez Scheme"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.4.tar.gz"
  sha256 "9f4e6fe737300878c3c9ca6ed09ed97fc2edbf40e4cf37bd61f48a27f5adf952"

  bottle do
    sha256 "c26b5a82277b69bc8f740ac713626edf4473c9c80ec68b2c2756be034586a33e" => :el_capitan
    sha256 "e695d2cd58784a22f6e32295501e7bbebf16c51439468e1f2f5931490cf15701" => :yosemite
    sha256 "25048c25d249169fd55de466bed0d751813825a948a549870cef5fb16cd220ab" => :mavericks
  end

  depends_on :x11 => build

  conflicts_with "mit-scheme", :because => "both install `scheme` binaries"

  def install
    system "./configure", "--installprefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS

    expected = <<-EOS.undent
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/scheme --script hello.ss")
  end
end
