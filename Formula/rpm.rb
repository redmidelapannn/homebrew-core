class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "http://www.rpm.org/"
  url "http://ftp.rpm.org/releases/rpm-4.14.x/rpm-4.14.0.tar.bz2"
  sha256 "06a0ad54600d3c42e42e02701697a8857dc4b639f6476edefffa714d9f496314"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 "4e487e5a4bbffc1302e3b11d75eaa879957678b14cae9b7c831ceb63afe1882e" => :sierra
    sha256 "aefc7e266d55ac0bcc82c7e523188f0f2656ca0300ae171b319027889e875e0d" => :el_capitan
  end

  depends_on "pkg-config" => :run
  depends_on "berkeley-db"
  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "xz"
  depends_on "zstd"

  def install
    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sharedstatedir=#{var}/lib",
                          "--sysconfdir=#{etc}",
                          "--with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic",
                          "--enable-nls",
                          "--disable-plugins",
                          "--with-external-db",
                          "--with-crypto=openssl",
                          "--without-apidocs",
                          "--with-vendor=homebrew"
    system "make", "install"
  end

  def post_install
    (var/"lib/rpm").mkpath

    # Attempt to fix expected location of GPG to a sane default.
    gnupg = Gpg.executable || HOMEBREW_PREFIX/"bin/gpg"
    inreplace lib/"rpm/macros", "/usr/bin/gpg2", gnupg
  end

  def test_spec
    <<~EOS
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
    (testpath/".rpmmacros").write <<~EOS
      %_topdir		#{testpath}/rpmbuild
      %_tmppath		%{_topdir}/tmp
    EOS

    system "#{bin}/rpm", "-vv", "-qa", "--dbpath=#{testpath}/var/lib/rpm"
    assert_predicate testpath/"var/lib/rpm/Packages", :exist?,
                     "Failed to create 'Packages' file!"
    rpmdir("%_builddir").mkpath
    specfile = rpmdir("%_specdir")+"test.spec"
    specfile.write(test_spec)
    system "#{bin}/rpmbuild", "-ba", specfile
    assert_predicate rpmdir("%_srcrpmdir")/"test-1.0-1.src.rpm", :exist?
    assert_predicate rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm", :exist?
    system "#{bin}/rpm", "-qpi", "--dbpath=#{testpath}/var/lib/rpm",
                         rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm"
  end
end
