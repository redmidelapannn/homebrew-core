class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.44.tgz"
  mirror "ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.44.tgz"
  sha256 "d7de6bf3c67009c95525dde3a0212cc110d0a70b92af2af8e3ee800e81b88400"

  bottle do
    rebuild 1
    sha256 "fdc2dd73c4a2fb6dc6415bcf2e1180338e7b6629d97f0ed913a27677d59442a2" => :sierra
    sha256 "470d72ec5cb4b5863e50484b11faba21d9d8dddf605cc67e13dca2ec9ddc5bc7" => :el_capitan
    sha256 "71539fc40fb2cbd2e7dc2828a01a443e292709488ee121143298e4c517628347" => :yosemite
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
