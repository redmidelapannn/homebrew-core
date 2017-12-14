class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.11.10.85.tar.gz"
  sha256 "63b078d7f8735eaf8c1e97d4b2b9f386fc765fad146ed66f19ae4a0fb4f60df7"
  head "https://github.com/roswell/roswell.git"

  bottle do
    rebuild 1
    sha256 "4786224b8c7f9a5e1a49f92d8f89c194f9e5460a73e296f83e6d644c85cc9d19" => :high_sierra
    sha256 "22b3a5608993e570c10640aed04f135c44cf8a865bad353395a218476e9b2633" => :sierra
    sha256 "238da78920fd16fc388e18ce7b17bb13f738864768444066eccf57ae424019ae" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
