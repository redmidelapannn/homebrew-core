class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.12/source/tarball/percona-xtrabackup-2.4.12.tar.gz"
  sha256 "de02cfd5bde96ddbf50339ef3a4646004dde52239698df45c19ed3e8ee40738e"

  bottle do
    rebuild 1
    sha256 "63a73275df4c5ea32f708c82f3b6f71e144a3801b37e66ec14a1ffcebacccbbb" => :high_sierra
    sha256 "6f9ded8440cc9dc851b82cf7f8171529a40e9c5543211e271a343de73dcbaead" => :sierra
    sha256 "c432322208e1a5330aa7de9b04d1562882e6228be13dc9f2072e5d6c2b1b5aa2" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "mysql-client"
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
    sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
  end

  def install
    cmake_args = %w[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_MANDIR=share/man
      -DWITH_MAN_PAGES=ON
    ]

    # macOS has this value empty by default.
    # See https://bugs.python.org/issue18378#msg215215
    ENV["LC_ALL"] = "en_US.UTF-8"

    # 1.59.0 specifically required. Detailed in cmake/boost.cmake
    (buildpath/"boost_1_59_0").install resource("boost")
    cmake_args << "-DWITH_BOOST=#{buildpath}/boost_1_59_0"

    cmake_args.concat std_cmake_args

    system "cmake", *cmake_args
    system "make"
    system "make", "install"

    share.install "share/man"

    rm_rf prefix/"xtrabackup-test" # Remove unnecessary files
    # remove conflicting libraries that are already installed by mysql
    rm lib/"libmysqlservices.a"
    rm lib/"plugin/keyring_file.so"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")
  end
end
