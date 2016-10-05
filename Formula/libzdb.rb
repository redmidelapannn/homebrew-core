class Libzdb < Formula
  desc "Database connection pool library"
  homepage "http://tildeslash.com/libzdb/"
  url "http://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"
  revision 2

  bottle do
    cellar :any
    sha256 "8c711fd4ac46e2a503f65059e630a63b1bd1a24d10f7ba8f67db5a70d5e75423" => :sierra
    sha256 "2de19c069451fa1c066cecc9b5ca1f12fe3fbb00dfdc0ac2070fe6932d5ae11a" => :el_capitan
    sha256 "2b32226d5efdec9f0cf5981ec0c497b1fe446b840bb44540a4a3b2ef0e0283db" => :yosemite
  end

  depends_on "openssl"
  depends_on :postgresql => :recommended
  depends_on :mysql => :recommended
  depends_on "sqlite" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--without-postgresql" if build.without? "postgresql"
    args << "--without-mysql" if build.without? "mysql"
    args << "--without-sqlite" if build.without? "sqlite"

    system "./configure", *args
    system "make", "install"
  end
end
