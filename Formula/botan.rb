class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.3.0.tgz"
  sha256 "39f970fee5986a4c3e425030aef50ac284da18596c004d1a9cce7688c4e6d47c"
  head "https://github.com/randombit/botan.git"

  bottle do
    rebuild 1
    sha256 "b9ec8bfebd524e84823752945799d6642beeb39fd360e0b9353ac2013d180a54" => :high_sierra
    sha256 "506babc2d7b559dffc566edab050d50f6caed19fdfd72b25459564ea23666926" => :sierra
    sha256 "ae052e48b13f65f6341df68ab506772850dbada73ce39ddb445023fc9e9edf2e" => :el_capitan
  end

  option "with-debug", "Enable debug build of Botan"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11

  # Fix build failure "error: no type named 'free' in namespace 'std'"
  # Upstream PR from 3 Oct 2017 "Add missing cstdlib include to openssl_rsa.cpp"
  if DevelopmentTools.clang_build_version < 900
    patch do
      url "https://github.com/randombit/botan/pull/1233.patch?full_index=1"
      sha256 "5ac83570d650d06cedb75e85a08287e5c62055dd1f159cede8a9b4b34b280600"
    end
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cpu=#{MacOS.preferred_arch}
      --cc=#{ENV.compiler}
      --os=darwin
      --with-openssl
      --with-zlib
      --with-bzip2
    ]

    args << "--with-debug" << "--debug-mode" if build.with? "debug"

    system "./configure.py", *args
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
