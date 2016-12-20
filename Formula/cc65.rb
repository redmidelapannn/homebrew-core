class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "ftp://ftp.musoftware.de/pub/uz/cc65/cc65-sources-2.13.3.tar.bz2"
  sha256 "a98a1b69d3fa15551fe7d53d5bebfc5f9b2aafb9642ee14b735587a421e00468"

  # CC65 stable has ceased to be maintained as of March 2013.
  # The head build has a new home, and new maintainer, but no new stable release yet.
  head "https://github.com/cc65/cc65.git"

  bottle do
    rebuild 1
    sha256 "fa853104643136711d25c8e09177d25f48fa28f3d4050c5c30eb6f686dcfea7d" => :sierra
    sha256 "ff4d5d9fdee5a24bfe22b58788c9085d7d5b5c6e643e04f79202cfc4c0f9eda0" => :el_capitan
    sha256 "c7707c75e2cd14c8b8303f306b85a29d43d5c777c66f64f13f2cebf50828d7b7" => :yosemite
  end

  conflicts_with "grc", :because => "both install `grc` binaries"

  def install
    ENV.deparallelize

    make_vars = ["prefix=#{prefix}", "libdir=#{share}"]

    if head?
      system "make", *make_vars
      system "make", "install", *make_vars
    else
      system "make", "-f", "make/gcc.mak", *make_vars
      system "make", "-f", "make/gcc.mak", "install", *make_vars
    end
  end

  def caveats; <<-EOS.undent
    Library files have been installed to:
      #{pkgshare}
    EOS
  end

  test do
    (testpath/"foo.c").write "int main (void) { return 0; }"

    system bin/"cl65", "foo.c" # compile and link
    assert File.exist?("foo")  # binary
  end
end
