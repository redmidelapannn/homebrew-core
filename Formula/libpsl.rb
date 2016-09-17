class Libpsl < Formula
  desc "C library for the Publix Suffix List"
  homepage "https://github.com/rockdaboot/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/libpsl-0.14.0/libpsl-0.14.0.tar.gz"
  sha256 "e8c794bcedf45c87dee4810570bc62ba7130217887e34e164e3eadc2259f2efb"

  bottle do
    cellar :any
    sha256 "3ff7f7a79d8d8dcaf6dfb054195d3c89ecc1b5b5e843b82210b1d7aae652ab3f" => :el_capitan
    sha256 "852945b9ca4ae4662d7489e093c171c8159c90b6972f30bbcceb66367a9c64ff" => :yosemite
    sha256 "6b911c8b1a62f5daf353ffc6f9d85024ae006f44061fe8010669ddfcf4ae1968" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "md5sha1sum" => :build
  # A build script (psl-make-dafsa) requires Python 2.7.
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "icu4c"

  def install
    # OS X doesn't follow PEP-394, so change psl-make-dafsa's shebang line to use Python 2.
    inreplace "src/psl-make-dafsa", "#!/usr/bin/env python2", "#!/usr/bin/env python"

    system "autoconf"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    test_output = shell_output("#{bin}/psl --print-unreg-domain www.example.com").strip
    assert_equal "www.example.com: com", test_output
  end
end
