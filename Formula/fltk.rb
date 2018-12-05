class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.4/fltk-1.3.4-2-source.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/fltk-1.3.4-2.tar.gz"
  version "1.3.4-2"
  sha256 "25d349c18c99508737d48f225a2eb26a43338f9247551cab72a317fa42cda910"

  bottle do
    rebuild 1
    sha256 "80e59cdf79a4444bc90a91687abef712fb2043728a6ea6514af8a4a164c0d0a3" => :mojave
    sha256 "b3e39ea374dbac8869d37dd9eef05b46a6bf8a1979d066db8d7402b4ff87e0ae" => :high_sierra
    sha256 "9cb1006892e5dbe72aafd7701701c4da41ac0b55fe6d326cab7092e7b5f0a1f1" => :sierra
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
