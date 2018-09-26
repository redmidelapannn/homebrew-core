class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.11.1.tar.gz"
  sha256 "9f6b3aeac5a109f55504bd370564ac431cb1773507929dc461626898f33f46cd"

  bottle do
    cellar :any
    rebuild 1
    sha256 "998722f77cd1d0a991778af9b0ea0e14adcfcd3ccf8d78bb9eba93eee805c4d0" => :mojave
    sha256 "23975dab91dde4996c499b6293b378589e5fde5f27b522f4686b8af39f467a8d" => :high_sierra
    sha256 "932413e6ca2519c901d61b783a30cbbaa71d39931b014dd8e804d1fca4897c8e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "libdnet"
  depends_on "luajit"
  depends_on "openssl"
  depends_on "pcre"

  def install
    openssl = Formula["openssl"]

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/snort
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-active-response
      --enable-flexresp3
      --enable-gre
      --enable-mpls
      --enable-normalizer
      --enable-react
      --enable-reload
      --enable-sourcefire
      --enable-targetbased
      --with-openssl-includes=#{openssl.opt_include}
      --with-openssl-libraries=#{openssl.opt_lib}
    ]

    system "./configure", *args
    system "make", "install"

    rm Dir[buildpath/"etc/Makefile*"]
    (etc/"snort").install Dir[buildpath/"etc/*"]
  end

  def caveats; <<~EOS
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod o+r /dev/bpf*
    or you could create a startup item to do this for you.
  EOS
  end

  test do
    system bin/"snort", "-V"
  end
end
