class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  # lnav.org has an SSL issue: https://github.com/tstack/lnav/issues/401
  homepage "https://github.com/tstack/lnav"
  url "https://github.com/tstack/lnav/releases/download/v0.8.2/lnav-0.8.2.tar.gz"
  sha256 "0f6a235aa3719f84067d510127730f5834a8874795494c9292c2f0de43db8c70"

  bottle do
    rebuild 1
    sha256 "998be355c1cb9246f51bffa562de27b4f37411a2fa6dce1a4d92d9f2fbb0a1ae" => :high_sierra
    sha256 "8fe6798a6080581d0321bfefc800bf448d40ef23e5cbf8757c4db0fe7f62135f" => :sierra
    sha256 "7612ff9586fc5a14095c52a9472b8d8224ffcd0299eac68bd0c816c52f608074" => :el_capitan
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "readline"
  depends_on "pcre"
  depends_on "libssh2" => :optional
  depends_on "sqlite" if MacOS.version < :sierra
  depends_on "curl" if build.with? "libssh2"

  def install
    # Fix errors such as "use of undeclared identifier 'sqlite3_value_subtype'"
    ENV.delete("SDKROOT")

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

    # macOS ships with libcurl by default, albeit without sftp support. If we
    # want lnav to use the keg-only curl formula that we specify as a
    # dependency, we need to pass in the path.
    args << "--with-libcurl=#{Formula["curl"].opt_lib}" if build.with? "curl"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
