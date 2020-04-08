class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  sha256 "f8a13466b48faa3ba99fe17a069e71c9ab006d9b1cfabe699f8c60a47d5bb49a"
  revision 1

  bottle do
    sha256 "df67f9000b0f111e33217bd29fef088f21a15af44e86c518f453f294b4078bfd" => :catalina
    sha256 "e5970698405d4bf6dda1e2020ac3b42a979ac5f8b52d2c457cde96a8fc2c74ec" => :mojave
    sha256 "8a0a7c991b99716ead9878d1f22cb1e6abf5fe23ccfe01f1bf4ee8d599191e2d" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "guile@2"

  uses_from_macos "libxml2"

  def install
    # Uses GNU-specific mktemp syntax: https://sourceforge.net/p/autogen/bugs/189/
    inreplace %w[agen5/mk-stamps.sh build-aux/run-ag.sh config/mk-shdefs.in], "mktemp", "gmktemp"
    # Upstream bug regarding "stat" struct: https://sourceforge.net/p/autogen/bugs/187/
    system "./configure", "ac_cv_func_utimensat=no",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end
