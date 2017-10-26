class Unittest < Formula
  desc "C++ Unit Test Framework"
  homepage "http://unittest.red-bean.com/"
  url "http://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz"
  sha256 "9586ef0149b6376da9b5f95a992c7ad1546254381808cddad1f03768974b165f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e448f26c42127801307edf6282bfe9e27f39cbf48019b02b5e659dc475dc8a8c" => :high_sierra
    sha256 "c0d62656838c24ab046181bb4c60fe8f30ef28a38b660bd1f877f669a54237f0" => :sierra
    sha256 "677a522e8f9a58eeb697631281f3361257ef296ba9380f57023be0e5190defc7" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "test/unittesttest"
  end

  test do
    system "#{pkgshare}/unittesttest"
  end
end
