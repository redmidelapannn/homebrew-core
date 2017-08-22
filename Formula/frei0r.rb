class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.6.1.tar.gz"
  sha256 "e0c24630961195d9bd65aa8d43732469e8248e8918faa942cfb881769d11515e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "03669c59744e7c2c3b89296736a9c9c4dc925032628c4732aa7a5a8ddfc03344" => :sierra
    sha256 "ef029dada8411c4f9caf02e76c125dd72a1ccc98aa2294327c7412d186580b52" => :el_capitan
    sha256 "5f7582a22c4d793fec706a433c38b80b1efcba4a5dbe780c84af22d8de790793" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo" => :optional
  depends_on "opencv@2" => :optional

  def install
    ENV["CAIRO_CFLAGS"] = "-I#{Formula["cairo"].opt_include}/cairo" if build.with? "cairo"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
