class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.31.1.tar.gz"
  sha256 "e88f8d36bd0a75d3765a4ad088d819e35f8d7ac6288049780e2fefcad18dde88"
  revision 2

  bottle do
    rebuild 1
    sha256 "adf5240470ef093d2d1f2d219d0c78a3d8171e58ac7ee11e9d5611890458d105" => :mojave
    sha256 "a8093202dfe5dbf59c6796b180afd77fd105915c944d222f463fb4fabff6cd03" => :high_sierra
    sha256 "4607dd3786c2f01c98181b4354f95b7290179b875c88c71e9f38e3485d81ad53" => :sierra
  end

  keg_only :provided_by_macos,
           "because Apple provides the same tools and binutils is poorly supported on macOS"

  # Adds support for macOS 10.14's new load commands.
  # Will be in the next release.
  # https://github.com/Homebrew/homebrew-core/issues/32516
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/91dc37fa4609cf1d040b5ede9f2eb971f3730597/binutils/add_mach_o_command.patch"
    sha256 "abb053663a56c5caef35685ee60badf57e321b18f308e7cbd11626b48c876e8c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
    Dir["#{bin}/*"].each do |f|
      bin.install_symlink f => "g" + File.basename(f)
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
