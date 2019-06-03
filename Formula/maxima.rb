class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.43.0-source/maxima-5.43.0.tar.gz"
  sha256 "dcfda54511035276fd074ac736e97d41905171e43a5802bb820914c3c885ca77"

  bottle do
    cellar :any_skip_relocation
    sha256 "94209a6b4627ca6a742139930d1b426299c3173e9cd3280ab7c1708d3df280da" => :mojave
    sha256 "676d0d657bfef7557083b240679d747a4980c4dd2556d5dc9e6b8fd8ac82e381" => :high_sierra
    sha256 "5487a37cc3b8354d0f29b265f2d0bb000b9fac1b43cb42c23625f638fdfecbc5" => :sierra
  end

  depends_on "sbcl" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gettext",
                          "--enable-sbcl",
                          "--enable-sbcl-exec",
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
