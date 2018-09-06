class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://downloads.sourceforge.net/project/pyqt/QScintilla2/QScintilla-2.10.4/QScintilla_gpl-2.10.4.tar.gz"
  sha256 "0353e694a67081e2ecdd7c80e1a848cf79a36dbba78b2afa36009482149b022d"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "dae857ed4737103e87727bbf10a4ece14c2134b9eb5032db4c0dc0ecb1abf1b7" => :mojave
    sha256 "824bc5e5cce2ee5856b6c967a95ee8f87067709410fbadddcf68db4b40e8a508" => :high_sierra
    sha256 "3b2a10e6a72ce9392c01b56097eab3a5ad8fd7749b5581a6291176bf46329361" => :sierra
    sha256 "ab404ec7d11098f56bd6689460ab8103d608e3f67484463284b671c6b7b61745" => :el_capitan
  end

  depends_on "pyqt"
  depends_on "python"
  depends_on "python@2"
  depends_on "qt"
  depends_on "sip"

  def install
    spec = (ENV.compiler == :clang && MacOS.version >= :mavericks) ? "macx-clang" : "macx-g++"
    args = %W[-config release -spec #{spec}]

    cd "Qt4Qt5" do
      inreplace "qscintilla.pro" do |s|
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
        s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", prefix/"trans"
        s.gsub! "$$[QT_INSTALL_DATA]", prefix/"data"
        s.gsub! "$$[QT_HOST_DATA]", prefix/"data"
      end

      inreplace "features/qscintilla2.prf" do |s|
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
      end

      system "qmake", "qscintilla.pro", *args
      system "make"
      system "make", "install"
    end

    # Add qscintilla2 features search path, since it is not installed in Qt keg's mkspecs/features/
    ENV["QMAKEFEATURES"] = prefix/"data/mkspecs/features"

    cd "Python" do
      Language::Python.each_python(build) do |python, version|
        (share/"sip").mkpath
        system python, "configure.py", "-o", lib, "-n", include,
                       "--apidir=#{prefix}/qsci",
                       "--destdir=#{lib}/python#{version}/site-packages/PyQt5",
                       "--stubsdir=#{lib}/python#{version}/site-packages/PyQt5",
                       "--qsci-sipdir=#{share}/sip",
                       "--qsci-incdir=#{include}",
                       "--qsci-libdir=#{lib}",
                       "--pyqt=PyQt5",
                       "--pyqt-sipdir=#{Formula["pyqt"].opt_share}/sip/Qt5",
                       "--sip-incdir=#{Formula["sip"].opt_include}",
                       "--spec=#{spec}"
        system "make"
        system "make", "install"
        system "make", "clean"
      end
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      import PyQt5.Qsci
      assert("QsciLexer" in dir(PyQt5.Qsci))
    EOS
    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end
end
