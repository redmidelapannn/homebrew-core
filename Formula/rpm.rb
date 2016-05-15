class RpmDownloadStrategy < CurlDownloadStrategy
  def stage
    tarball_name = "#{name}-#{version}.tar.gz"
    safe_system "rpm2cpio.pl <#{cached_location} | cpio -vi #{tarball_name}"
    safe_system "/usr/bin/tar -xzf #{tarball_name} && rm #{tarball_name}"
    chdir
  end

  def ext
    ".src.rpm"
  end
end

class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "http://www.rpm5.org/"
  url "http://rpm5.org/files/rpm/rpm-5.4/rpm-5.4.16-0.20160420.src.rpm",
      :using => RpmDownloadStrategy
  version "5.4.16"
  sha256 "0a7ec6e27a2e2a80e409bd5d774db66a847de141ebb1c3f5ae4fc42ce1a7d1b9"

  bottle do
    sha256 "257e1d75cfa5d3f858a578b400ff7edf42924a68f934f3a3de01f3835d10fbb2" => :el_capitan
    sha256 "1cb1a09802a55f81a13832b8b66e79d605f67875c800b17ef3dbe17edcc64968" => :yosemite
    sha256 "445918f663e550cb91625eec2e7b5ec063aa1a290729ff85e5b4d64085bfbbac" => :mavericks
  end

  depends_on "rpm2cpio" => :build
  depends_on "berkeley-db5"
  depends_on "libmagic"
  depends_on "popt"
  depends_on "libtomcrypt"
  depends_on "libtasn1"
  depends_on "gettext"
  depends_on "xz"
  depends_on "ossp-uuid"
  depends_on "lua"
  depends_on "syck"
  depends_on "openssl"

  patch do
    url "http://rpm5.org/cvs/patchset?cn=18870"
    sha256 "5504de66494d82764358ef7fdeb2acf8d54d165b0b4806ce1cf9e44554aceaf2"
  end
  patch do
    url "http://rpm5.org/cvs/patchset?cn=18871"
    sha256 "210d6bfa4d3716e3cb86f1174b6a32928f0fc9cd3c90da06fae9716259101fa5"
  end
  patch do
    url "http://rpm5.org/cvs/patchset?cn=18872"
    sha256 "b7be17b0e9c91094081a0db95f17f61c73389f4fcd2b0378cc8bf559b6355d37"
  end
  patch do
    url "http://rpm5.org/cvs/patchset?cn=18873"
    sha256 "9feecfdf576467912c8e0da097476ed700ff73aec82827343be5741c680d060e"
  end

  def install
    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace "macros/macros.in", "@prefix@", HOMEBREW_PREFIX
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --with-path-cfg=#{etc}/rpm
      --with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic
      --with-path-sources=#{var}/lib/rpmbuild
      --with-libiconv-prefix=/usr
      --disable-openmp
      --disable-nls
      --disable-dependency-tracking
      --with-db=external
      --with-sqlite=external
      --with-file=external
      --with-popt=external
      --with-beecrypt=internal
      --with-tomcrypt=external
      --with-libtasn1=external
      --with-neon=internal
      --with-zlib=external
      --with-bzip2=external
      --with-xz=external
      --with-uuid=external
      --with-pcre=internal
      --with-lua=external
      --with-syck=external
      --with-openssl=external
      --with-sasl2=external
      --without-apidocs
      varprefix=#{var}
    ]

    # use db5, until db6 is stable (in BDB 6.2 ?)
    inreplace "configure", "DBXY=db61", "DBXY=db"
    inreplace "configure", "db-6.1", "db-5.3"
    inreplace "configure", "db_sql-6.1", "db_sql-5.3"
    # dyld: lazy symbol binding failed: Symbol not found: _SSL_library_init
    ENV["LIBS"] = "-lssl"
    system "./configure", *args
    inreplace "config.h", "/* #undef USE_LTC_LTC_PKCS_1_V1_5 */", "#define USE_LTC_LTC_PKCS_1_V1_5 1"
    inreplace "rpmdb/Makefile", " -Dapi.pure", ""
    inreplace "rpmio/Makefile", " -lrt", ""
    system "make"
    # using __scriptlet_requires needs bash --rpm-requires
    inreplace "macros/macros.rpmbuild", "%_use_internal_dependency_generator\t2", "%_use_internal_dependency_generator\t1"
    # warning: rpmbcGenerate(ECDSA): skipped (unimplemented)
    inreplace "macros/macros.rpmbuild", "%_build_sign\tECDSA/SHA256", "%_build_sign\tRSA/SHA256"
    system "make", "install"
  end

  def test_spec
    <<-EOS.undent
      Summary:   Test package
      Name:      test
      Version:   1.0
      Release:   1
      License:   Public Domain
      Group:     Development/Tools
      BuildArch: noarch

      %description
      Trivial test package

      %prep
      %build
      %install
      mkdir -p $RPM_BUILD_ROOT/tmp
      touch $RPM_BUILD_ROOT/tmp/test

      %files
      /tmp/test

      %changelog

    EOS
  end

  def rpmdir(macro)
    Pathname.new(`#{bin}/rpm --eval #{macro}`.chomp)
  end

  test do
    (testpath/"rpmbuild").mkpath
    (testpath/".rpmmacros").write <<-EOS.undent
      %_topdir		#{testpath}/rpmbuild
      %_tmppath		%{_topdir}/tmp
    EOS

    system "#{bin}/rpm", "-vv", "-qa", "--dbpath=#{testpath}/var/lib/rpm"
    assert File.exist?(testpath/"var/lib/rpm/Packages")
    rpmdir("%_builddir").mkpath
    specfile = rpmdir("%_specdir")+"test.spec"
    specfile.write(test_spec)
    system "#{bin}/rpmbuild", "-ba", specfile
    assert File.exist?(rpmdir("%_srcrpmdir")/"test-1.0-1.src.rpm")
    assert File.exist?(rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm")
    system "#{bin}/rpm", "-qpi", "--dbpath=#{testpath}/var/lib/rpm",
                         rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm"

    system "#{bin}/rpm", "-v", "-i", "--dbpath=#{testpath}/var/lib/rpm", "--justdb", "--nodeps",
                         rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm"
    system "#{bin}/rpm", "-v", "-e", "--dbpath=#{testpath}/var/lib/rpm", "--justdb", "--nodeps",
                         "test-1.0-1"
  end
end
