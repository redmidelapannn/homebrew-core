class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://expect.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz"
  sha256 "49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34"
  revision 1

  bottle do
    sha256 "3addaf0de76ba525dcfe2dcb9820578020dd39f32f8117d294f02ded6d321bef" => :mojave
    sha256 "0d8f581af9c0c723ab0a1ed9e4f183265338e13c940740fd2483c362bf3d7a67" => :high_sierra
    sha256 "648945349b7f19e768e0771800220dcd1aff0acad0e29715ae0baa1c156fca5d" => :sierra
  end

  option "with-threads", "Build with multithreading support"
  option "with-brewed-tk", "Use Homebrew's Tk (has Cocoa and threads support)"

  deprecated_option "enable-threads" => "with-threads"

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "tcl-tk" if build.with? "brewed-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --enable-shared
    ]
    args << "--enable-threads" if build.with? "threads"
    args << "--enable-64bit" if MacOS.prefer_64_bit?

    if build.with? "brewed-tk"
      args << "--with-tcl=#{Formula["tcl-tk"].opt_prefix}/lib"
    else
      ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers/tcl-private"
      args << "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    end

    # Regenerate configure script. Remove after patch applied in newer
    # releases.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir[lib/"expect*/libexpect*"]
  end

  test do
    system "#{bin}/mkpasswd"
  end
end
