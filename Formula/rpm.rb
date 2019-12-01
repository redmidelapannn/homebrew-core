class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  url "http://ftp.rpm.org/releases/rpm-4.15.x/rpm-4.15.1.tar.bz2"
  sha256 "ddef45f9601cd12042edfc9b6e37efcca32814e1e0f4bb8682d08144a3e2d230"
  revision 1
  version_scheme 1

  bottle do
    sha256 "f2449c900e9c5d0547d17ba6f2917d5931f1da1c39487c25e1486a658afc892e" => :catalina
    sha256 "7f0d12a2f01a9fa4b95c5fead03cd91c94c67c4fdee104a90229808472f47c15" => :mojave
    sha256 "554b14744a55813bbcdbc88bf9b144b65e2397693ebff478eea4766e8da4a186" => :high_sierra
  end

  depends_on "berkeley-db"
  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "libomp"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "popt"
  depends_on "python"
  depends_on "xz"
  depends_on "zstd"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua"].opt_libexec/"lib/pkgconfig"
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-lomp"

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    # ensure that pkg-config binary is found for dep generators
    inreplace "scripts/pkgconfigdeps.sh",
              "/usr/bin/pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sharedstatedir=#{var}/lib",
                          "--sysconfdir=#{etc}",
                          "--with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic",
                          "--enable-nls",
                          "--enable-python",
                          "--disable-plugins",
                          "--with-external-db",
                          "--with-crypto=openssl",
                          "--with-python=python3",
                          "--without-apidocs",
                          "--with-vendor=homebrew",
                          "PYTHON=#{Formula["python"].opt_bin}/python3"
    system "make", "install"
  end

  def post_install
    (var/"lib/rpm").mkpath

    # Attempt to fix expected location of GPG to a sane default.
    inreplace lib/"rpm/macros", "/usr/bin/gpg2", HOMEBREW_PREFIX/"bin/gpg"
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

    # Falsely flagged by RuboCop.
    # rubocop:disable Style/FormatStringToken
    (testpath/".rpmmacros").write <<~EOS
      %_topdir		#{testpath}/rpmbuild
      %_tmppath		%{_topdir}/tmp
    EOS
    # rubocop:enable Style/FormatStringToken

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
    system "python3", "-c", "import rpm"
  end
end
