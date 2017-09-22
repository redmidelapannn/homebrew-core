class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://msmtp.sourceforge.io"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.6.6/msmtp-1.6.6.tar.xz"
  sha256 "da15db1f62bd0201fce5310adb89c86188be91cd745b7cb3b62b81a501e7fb5e"

  bottle do
    rebuild 1
    sha256 "5197bbc30034ecf7f7b4c40411282d62140408541fa6dfeab25e6f1675a90b6a" => :sierra
    sha256 "e7e344973b7653f907557a6e19ecf22510ffdaf9ece37bd7722fd4731b69a55c" => :el_capitan
  end

  option "with-gsasl", "Use GNU SASL authentication library"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "gsasl" => :optional

  def install
    # Fix dyld: lazy symbol binding failed: Symbol not found: _fmemopen
    if MacOS.version == :sierra && MacOS::Xcode.installed? &&
       MacOS::Xcode.version >= "9.0"
      ENV["ac_cv_func_fmemopen"] = "no"
    end

    args = %W[
      --disable-dependency-tracking
      --with-macosx-keyring
      --prefix=#{prefix}
      --with-tls=openssl
    ]

    args << "--with-libsasl" if build.with? "gsasl"

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
