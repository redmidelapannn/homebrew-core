class MesalibGlw < Formula
  desc "Open-source implementation of the OpenGL specification"
  homepage "https://www.mesa3d.org"
  url "https://downloads.sourceforge.net/project/mesa3d/MesaLib/7.2/MesaLib-7.2.tar.gz"
  sha256 "a7b7cc8201006685184e7348c47cb76aecf71be81475c71c35e3f5fe9de909c6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a19bee855c87b9ca312649227d3249b96a5b27e5ea6dd0eaf088c423fef3b299" => :sierra
    sha256 "61cd51399b61a3281f2b647a6258e50c74de5f44e7f696ed8d34d233b24d7364" => :el_capitan
    sha256 "41b605371e08b6aed7dd6991803d0eb3df52e62e3cedb84b3132220e13e4b585" => :yosemite
  end

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-driver=xlib",
                          "--disable-gl-osmesa",
                          "--disable-glu",
                          "--disable-glut"

    inreplace "configs/autoconf" do |s|
      s.gsub! /.so/, ".dylib"
      s.gsub! /SRC_DIRS = mesa glw/, "SRC_DIRS = glw"
      s.gsub! %r{-L\$\(TOP\)/\$\(LIB_DIR\)}, "-L#{MacOS::X11.lib}"
    end

    inreplace "src/glw/Makefile", %r{-I\$\(TOP\)/include }, ""

    system "make"

    (include+"GL").mkpath
    (include+"GL").install Dir["src/glw/*.h"]
    lib.install Dir["lib/*"]
  end
end
