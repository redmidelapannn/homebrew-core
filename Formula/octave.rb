class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-4.4.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/octave/octave-4.4.1.tar.xz"
  sha256 "7e4e9ac67ed809bd56768fb69807abae0d229f4e169db63a37c11c9f08215f90"
  revision 4

  bottle do
    rebuild 1
    sha256 "c53bf28362b810737782161f02576e026b8f62f3371bf6b29a426afedc9134d6" => :mojave
    sha256 "e61688bbda2ecc9e6118cdee004dd101d9969360ecb128613cdcd36d6c8e955f" => :high_sierra
    sha256 "6641fee33f9b6f693bf9d88c339c4d0dcc64d69c15d89a3e4313bc2d7a0752bb" => :sierra
  end

  head do
    url "https://hg.savannah.gnu.org/hgweb/octave", :branch => "default", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
  end

  # Complete list of dependencies at https://wiki.octave.org/Building
  depends_on "gnu-sed" => :build # https://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on :java => ["1.6+", :build, :test]
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "epstool"
  depends_on "fftw"
  depends_on "fig2dev"
  depends_on "fltk"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "ghostscript"
  depends_on "gl2ps"
  depends_on "glpk"
  depends_on "gnuplot"
  depends_on "graphicsmagick"
  depends_on "hdf5"
  depends_on "libsndfile"
  depends_on "libtool"
  depends_on "pcre"
  depends_on "portaudio"
  depends_on "pstoedit"
  depends_on "qhull"
  depends_on "qrupdate"
  depends_on "readline"
  depends_on "suite-sparse"
  depends_on "sundials"
  depends_on "texinfo"
  depends_on "veclibfort"

  depends_on "qt" => :optional

  # Dependencies use Fortran, leading to spurious messages about GCC
  cxxstdlib_check :skip

  def install
    # Default configuration passes all linker flags to mkoctfile, to be
    # inserted into every oct/mex build. This is unnecessary and can cause
    # cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    args = []
    if build.with? "qt"
      args << "--with-qt"
      qcollection = "#{Formula["qt"].bin}/qcollectiongenerator"
      unless File.exist?(qcollection)
        odie "octave configure script checks for qcollectiongenerator " \
        "bin to use qt gui feature, but it is not bundled with qt5 formula, " \
        "so we can fake it by make a symbol link for it, for example, " \
        "ln -s {Cellar}/qt/5.12.0/bin/qhelpgenerator {Cellar}/qt/5.12.0/bin/qcollectiongenerator"
      end

      # to fix by making a symbol link is prohibited by macOS (https://github.com/Homebrew/brew/issues/3002)
      # qhelp = "#{Formula["qt"].bin}/qhelpgenerator"
      # if File.exist?(qhelp)
      #   qcollection = "#{Formula["qt"].bin}/qcollectiongenerator"
      #   if not File.exist?(qcollection)
      #     ln_s "#{qhelp}","#{qcollection}", :force=>true
      #   end
      # end
    end

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-link-all-dependencies",
                          "--enable-shared",
                          "--disable-static",
                          "--without-osmesa",
                          "--with-hdf5-includedir=#{Formula["hdf5"].opt_include}",
                          "--with-hdf5-libdir=#{Formula["hdf5"].opt_lib}",
                          "--with-x=no",
                          "--with-blas=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort",
                          "--with-portaudio",
                          "--with-sndfile",
                          *args
    system "make", "all"

    # Avoid revision bumps whenever fftw's or gcc's Cellar paths change
    inreplace "src/mkoctfile.cc" do |s|
      s.gsub! Formula["fftw"].prefix.realpath, Formula["fftw"].opt_prefix
      s.gsub! Formula["gcc"].prefix.realpath, Formula["gcc"].opt_prefix
    end

    # Make sure that Octave uses the modern texinfo at run time
    rcfile = buildpath/"scripts/startup/site-rcfile"
    rcfile.append_lines "makeinfo_program(\"#{Formula["texinfo"].opt_bin}/makeinfo\");"

    system "make", "install"
  end

  test do
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # This is supposed to crash octave if there is a problem with veclibfort
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
    # Test java bindings: check if javaclasspath is working, return error if not
    system bin/"octave", "--eval", "try; javaclasspath; catch; quit(1); end;"
  end
end
