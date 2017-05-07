class Nacl < Formula
  desc "Network communication, encryption, decryption, signatures library"
  homepage "https://nacl.cr.yp.to/"
  url "https://hyperelliptic.org/nacl/nacl-20110221.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nacl/nacl_20110221.orig.tar.bz2"
  sha256 "4f277f89735c8b0b8a6bbd043b3efb3fa1cc68a9a5da6a076507d067fc3b3bf8"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "d9fc2991ce9284921a7ecadbf9b500b21178ca7a55609c0f177dee0042a22410" => :sierra
    sha256 "eed0295c8a035c0166c09a327adacef9c72c0dbc21d2a8e95952eed2d77037ff" => :el_capitan
    sha256 "7ac08385b8478962dc90c9ab6f5f1b4e16493fe7c652e14df2d11b7f4fd7668d" => :yosemite
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

    # NaCL has an odd compilation model and installs the resulting
    # binaries in a directory like:
    #    <nacl source>/build/<hostname>/lib/<arch>/libnacl.a
    #    <nacl source>/build/<hostname>/include/<arch>/crypto_box.h
    #
    # It also builds both x86 and x86_64 copies if your compiler can
    # handle it, but we install only one.
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
