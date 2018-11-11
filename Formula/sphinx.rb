class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  head "https://github.com/sphinxsearch/sphinx.git"

  bottle do
    rebuild 1
    sha256 "163ce53541c366d71b58539fc3aebcf74adb5da68c2e7b943f58e7dd68406443" => :mojave
    sha256 "09593de607ac1df65f20a873bcfb013338f1e1a03c62ac183a299fb3ab7ac98d" => :high_sierra
    sha256 "559d16effa71de6e300bb64226ca7efec0ad31fdba25d23437d8cdbb6e82c572" => :sierra
  end

  option "with-mysql", "Force compiling against MySQL"
  option "with-mysql@5.7", "Force compiling against MySQL 5.7"
  option "with-postgresql", "Force compiling against PostgreSQL"

  deprecated_option "mysql" => "with-mysql"
  deprecated_option "pgsql" => "with-postgresql"

  depends_on "mysql" => :optional
  depends_on "mysql@5.7" => :optional
  depends_on "openssl" if build.with?("mysql") || build.with?("mysql@5.7")
  depends_on "postgresql" => :optional

  fails_with :clang do
    build 421
    cause "sphinxexpr.cpp:1802:11: error: use of undeclared identifier 'ExprEval'"
  end

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
        :revision => "9b58e92c965cd7e3208247ace3cc00d173397f3c"
  end

  def install
    resource("stemmer").stage do
      system "make", "dist_libstemmer_c"
      system "tar", "xzf", "dist/libstemmer_c.tgz", "-C", buildpath
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --localstatedir=#{var}
      --with-libstemmer
    ]

    if build.with?("mysql") || build.with?("mysql@5.7")
      args << "--with-mysql"
    else
      args << "--without-mysql"
    end

    if build.with? "postgresql"
      args << "--with-pgsql"
    else
      args << "--without-pgsql"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    This is not sphinx - the Python Documentation Generator.
    To install sphinx-python use pip.

    Sphinx has been compiled with libstemmer support.

    Sphinx depends on either MySQL or PostreSQL as a datasource.

    You can install these with Homebrew with:
      brew install mysql
        For MySQL server.

      brew install mysql-connector-c
        For MySQL client libraries only.

      brew install postgresql
        For PostgreSQL server.

    We don't install these for you when you install this formula, as
    we don't know which datasource you intend to use.
  EOS
  end

  test do
    system bin/"searchd", "--help"
  end
end
