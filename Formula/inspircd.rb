class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.1.0.tar.gz"
  sha256 "5fd6b30e0285dd2bcf6fd135ffce52a08d8452f820a02e0068ac471e99d465ba"

  bottle do
    sha256 "95de3174fd3eb4bb6455de0e813f07237611021e8f8e7cbcef84852dfdc6aa16" => :mojave
    sha256 "8934794a8c1dfcf66f343feb6b3bff4f69fe1d74d9a43af7345c192b82061ef7" => :high_sierra
    sha256 "1d696589a4ea91e847ed182fe6ebccdcaa266609a0e536654ad6388bcb897c4c" => :sierra
  end

  if MacOS.version <= :sierra
    depends_on "openssl" => :build
  end

  depends_on "pkg-config" => :build

  skip_clean "data"
  skip_clean "logs"

  def install
    system "./configure", "--enable-extras=m_ldapauth.cpp,m_ldapoper.cpp"
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system "#{bin}/inspircd", "--version"
  end
end
