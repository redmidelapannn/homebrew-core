class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "http://www.fltk.org/"
  url "http://fltk.org/pub/fltk/1.3.4/fltk-1.3.4-source.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/fltk/fltk-1.3.4-source.tar.gz"
  mirror "https://fossies.org/linux/misc/fltk-1.3.4-source.tar.gz"
  sha256 "c8ab01c4e860d53e11d40dc28f98d2fe9c85aaf6dbb5af50fd6e66afec3dc58f"

  bottle do
    rebuild 1
    sha256 "0c34649a9a8581d2226307afb1efd53592bf115f0b5edfef627258340f07f027" => :sierra
    sha256 "648ff4370d45b7853e44621ac0645f06fee138697fc3d033a82f7559fd642467" => :el_capitan
    sha256 "b96b5b1f640f34ea669ace3ff59738e8c19379fd216ec1e5fbab3b6e1573593e" => :yosemite
  end

  depends_on "libpng"
  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
