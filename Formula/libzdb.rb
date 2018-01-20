class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"
  revision 5

  bottle do
    cellar :any
    rebuild 1
    sha256 "dfee4e15817924dc36c1c110e7c144e7eed4aa2bb82e562ed56d70c1aaa21b5f" => :high_sierra
    sha256 "043f64ce72e23b537a3601fec4876642fd8ff75c36a5d0f08096a01ad3c09c7a" => :sierra
    sha256 "17141c59cf8a918d0ae5f7c4b50a365949963dc3fc2738e2e241e5fb1a309b3a" => :el_capitan
  end

  depends_on "openssl"
  depends_on "postgresql" => :recommended
  depends_on "mysql" => :recommended
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
