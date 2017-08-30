class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.45.tgz"
  mirror "ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.45.tgz"
  sha256 "cdd6cffdebcd95161a73305ec13fc7a78e9707b46ca9f84fb897cd5626df3824"

  bottle do
    rebuild 1
    sha256 "03e9578b166a1e0ba7bce74fca931c24a97461ae54cf3d6de4b9f5ac6741fb16" => :sierra
    sha256 "0b31f81ce8a1394427a490a394c8457d77405ec5aadbb2d8ee1d1597c8713e8a" => :el_capitan
    sha256 "482950de2d5e87230d85dc7fa78e4be3bd2d1d70430645a01421170c72e8920d" => :yosemite
  end

  keg_only :provided_by_osx

  option "with-sssvlv", "Enable server side sorting and virtual list view"

  depends_on "berkeley-db@4" => :optional
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
      --with-pic
    ]

    args << "--enable-bdb=no" << "--enable-hdb=no" if build.without? "berkeley-db@4"
    args << "--enable-sssvlv=yes" if build.with? "sssvlv"

    system "./configure", *args
    system "make", "install"
    (var+"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
