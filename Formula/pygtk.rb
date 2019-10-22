class Pygtk < Formula
  desc "GTK+ bindings for Python"
  homepage "http://www.pygtk.org/"
  url "https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2"
  sha256 "cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912"
  revision 3

  bottle do
    cellar :any
    rebuild 3
    sha256 "06c4268a37706d11bf9dda81b2157775485377be807b10342a8a076cf2987f8c" => :catalina
    sha256 "470eea538473ef3dc80fcf79c9b37a723836acb6c09aa4551cf93ae72908d0a9" => :mojave
    sha256 "a698cee4e566bcf2cea59f72046d75be8e34c60b2289fa3b748fc3253032a6da" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "libglade"
  depends_on "py2cairo"
  depends_on "pygobject"

  # Allow building with recent Pango, where some symbols were removed
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/pygtk/2.24.0.diff"
    sha256 "ec480cff20082c41d9015bb7f7fc523c27a2c12a60772b2c55222e4ba0263dde"
  end

  def install
    ENV.append "CFLAGS", "-ObjC"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Fixing the pkgconfig file to find codegen, because it was moved from
    # pygtk to pygobject. But our pkgfiles point into the cellar and in the
    # pygtk-cellar there is no pygobject.
    inreplace lib/"pkgconfig/pygtk-2.0.pc", "codegendir=${datadir}/pygobject/2.0/codegen", "codegendir=#{HOMEBREW_PREFIX}/share/pygobject/2.0/codegen"
    inreplace bin/"pygtk-codegen-2.0", "exec_prefix=${prefix}", "exec_prefix=#{Formula["pygobject"].opt_prefix}"
  end

  test do
    (testpath/"codegen.def").write("(define-enum asdf)")
    system "#{bin}/pygtk-codegen-2.0", "codegen.def"
  end
end
