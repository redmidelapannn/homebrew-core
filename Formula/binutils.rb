class Binutils < Formula
  desc "FSF/GNU ld, ar, readelf, etc. for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.29.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.29.1.tar.gz"
  sha256 "0d9d2bbf71e17903f26a676e7fba7c200e581c84b8f2f43e72d875d0e638771c"
  revision 1

  bottle do
    sha256 "bd3c50c3354352964bbc987e91de7a29ab6146b8c745067bc4441909e5c575f1" => :high_sierra
    sha256 "2cd3f956987315f6b1820be6deee8e22049aff2ef6d32f9fd31138f7fe57f421" => :sierra
    sha256 "202ac77d91a541874b1419fd2f76c2fd31a697bbf2c55f9e14a7d9e8622a8a46" => :el_capitan
  end

  def install
    # No --default-names option as it interferes with Homebrew builds.
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    # Do "make" in buildpath at first.
    # See http://forum.osdev.org/viewtopic.php?p=262707&sid=8a5a5d70c93acab73c5325f629216a91#p262707
    system "make"
    system "make", "install"
    cd "gprof" do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--infodir=#{info}",
                            "--mandir=#{man}",
                            "--enable-plugins",
                            "--disable-werror"
      system "make", "install"
    end
    cd "gas" do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--infodir=#{info}",
                            "--mandir=#{man}",
                            "--enable-plugins",
                            "--disable-werror",
                            "--program-prefix=g",
                            "--with-system-zlib"
      # Adjustment to install a original named binary into same directry of other original named binarys.
      inreplace "Makefile", "$(tooldir)", "#{prefix}/$(target)"
      system "make", "install"
    end
  end

  test do
    assert_match "main", shell_output("#{bin}/gnm #{bin}/gnm")
  end
end
