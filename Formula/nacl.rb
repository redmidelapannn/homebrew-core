class Nacl < Formula
  desc "Network communication, encryption, decryption, signatures library"
  homepage "https://nacl.cr.yp.to/"
  url "https://hyperelliptic.org/nacl/nacl-20110221.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nacl/nacl_20110221.orig.tar.bz2"
  sha256 "4f277f89735c8b0b8a6bbd043b3efb3fa1cc68a9a5da6a076507d067fc3b3bf8"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "303e071d8a415ea757892f0fea986baec33a7caad36ebb7a1daecadc5c23f90f" => :sierra
    sha256 "5eaab5e4d14b97ff78d293b10ba0d72908a469b13f3d44a20c76d520aeca77d3" => :el_capitan
    sha256 "0c58b6b390356dece8895e95101ed7706f7d4114a74a7b35762ad8be43353179" => :yosemite
  end

  def install
    # Print the build to stdout rather than the default logfile.
    # Logfile makes it hard to debug and spot hangs. Applied by Debian:
    # https://sources.debian.net/src/nacl/20110221-4.1/debian/patches/output-while-building/
    # Also, like Debian, inreplace the hostname because it isn't used outside
    # build process and adds an unpredictable factor.
    inreplace "do" do |s|
      s.gsub! 'exec >"$top/log"', 'exec | tee "$top/log"'
      s.gsub! /^shorthostname=`.*$/, "shorthostname=brew"
    end

    system "./do" # This takes a while since it builds *everything*

    # NaCL has an odd compilation model (software by djb, who'da thunk it?)
    # and installs the resulting binaries in a directory like:
    #    <nacl source>/build/<hostname>/lib/<arch>/libnacl.a
    #    <nacl source>/build/<hostname>/include/<arch>/crypto_box.h
    # etc. Each of these is optimized for the specific hardware it's
    # compiled on.
    #
    # It also builds both x86 and x86_64 copies if your compiler can
    # handle it. Here we only install one copy, based on if you're a
    # 64bit system or not. A --universal could come later though I guess.
    archstr = Hardware::CPU.is_64_bit? ? "amd64" : "x86"

    # Don't include cpucycles.h
    include.install Dir["build/brew/include/#{archstr}/crypto_*.h"]
    include.install "build/brew/include/#{archstr}/randombytes.h"

    # Add randombytes.o to the libnacl.a archive - I have no idea why it's separated,
    # but plenty of the key generation routines depend on it. Users shouldn't have to
    # know this.
    nacl_libdir = "build/brew/lib/#{archstr}"
    system "ar", "-r", "#{nacl_libdir}/libnacl.a", "#{nacl_libdir}/randombytes.o"
    lib.install "#{nacl_libdir}/libnacl.a"
  end
end
