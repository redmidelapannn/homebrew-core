class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "https://cclive.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cclive/0.9/cclive-0.9.3.tar.xz"
  sha256 "2edeaf5d76455723577e0b593f0322a97f1e0c8b0cffcc70eca8b5d17374a495"

  bottle do
    cellar :any
    sha256 "df88640b0e73db346f77c4706ed493ab4eb649155778bf29e3779b8a759444e0" => :high_sierra
    sha256 "56df545f4a17318c3345a11d9d5de8b0dc92736407b9b71e2cf0af7287105350" => :sierra
    sha256 "fe6add4113927096b98025ea882947cd30743f674834be15a702b780b5361dc3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "glibmm"
  depends_on "libquvi"
  depends_on "pcre"

  conflicts_with "clozure-cl", :because => "both install a ccl binary"

  # Upstream PR from 26 Dec 2014 "Add explicit <iostream> includes, fixes build
  # with Boost 1.56"
  patch do
    url "https://github.com/legatvs/cclive/pull/2.patch?full_index=1"
    sha256 "a4cc99e6b78701c8106871b690c899b95d36d8f873ff4d212e63d8f3f45a990f"
  end

  # Fix build errors due to assumption of glibc's strerror_r and due to C++11
  # requirement that there be a space between literal and identifier.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1266537/cclive/cxx11-and-strerror_r.diff"
    sha256 "38ce495646de295e8cb2d6712d82f2d995db0601649197bc17ab01c5027e7845"
  end

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    url = "https://youtu.be/VaVZL7F6vqU"
    output = shell_output("#{bin}/cclive --no-download #{url} 2>&1")
    assert_match "Martin Luther King Jr Day", output
  end
end
