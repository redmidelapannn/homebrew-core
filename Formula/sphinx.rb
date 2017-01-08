class Sphinx < Formula
  desc "Full-text search engine"
  homepage "http://www.sphinxsearch.com"
  url "http://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  head "https://github.com/sphinxsearch/sphinx.git"

  bottle do
    rebuild 1
    sha256 "42ace4bf14ac891306c2c68eff8e412cd63769098eff60d729ca6ec366c387c3" => :sierra
    sha256 "2328f674d4cc298c940eda6833b6dfa8d21f943bfa267fc583b05e4c4c44f720" => :el_capitan
    sha256 "a4bc182e52072a86b458c1fc30c5552085e44e4900f8573c99de649d92d8a997" => :yosemite
  end

  option "with-mysql", "Force compiling against MySQL"
  option "with-postgresql", "Force compiling against PostgreSQL"
  option "with-id64", "Force compiling with 64-bit ID support"

  deprecated_option "mysql" => "with-mysql"
  deprecated_option "pgsql" => "with-postgresql"
  deprecated_option "id64" => "with-id64"

  depends_on "re2" => :optional
  depends_on :mysql => :optional
  depends_on :postgresql => :optional
  depends_on "openssl" if build.with? "mysql"

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
        :revision => "9b58e92c965cd7e3208247ace3cc00d173397f3c"
  end

  fails_with :clang do
    build 421
    cause "sphinxexpr.cpp:1802:11: error: use of undeclared identifier 'ExprEval'"
  end

  needs :cxx11 if build.with? "re2"

  def install
    if build.with? "re2"
      ENV.cxx11

      # Fix "error: invalid suffix on literal" and "error:
      # non-constant-expression cannot be narrowed from type 'long' to 'int'"
      # Upstream issue from 7 Dec 2016 http://sphinxsearch.com/bugs/view.php?id=2578
      ENV.append "CXXFLAGS", "-Wno-reserved-user-defined-literal -Wno-c++11-narrowing"
    end

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

    args << "--enable-id64" if build.with? "id64"
    args << "--with-re2" if build.with? "re2"

    if build.with? "mysql"
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

  def caveats; <<-EOS.undent
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
