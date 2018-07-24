class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v18.6.10.92.tar.gz"
  sha256 "d1d2fc0da0981f6696f3b08a0b8b2547d2230e10ba32e7290c5472a2a7793c30"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "63179d946ddaaa588a1825419c8d431dae528099c96a80a33bfa91b02cffbd21" => :high_sierra
    sha256 "0884a9a0db77b409606bd73aa919f5a298ea1143392dd1895502f517f9449c42" => :sierra
    sha256 "0b33d6f8c4ad97f49cd243371fecc69ef447abf5bc32ff5ab35052bf7bb17f30" => :el_capitan
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
