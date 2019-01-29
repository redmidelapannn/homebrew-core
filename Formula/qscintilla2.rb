class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://downloads.sourceforge.net/project/pyqt/QScintilla2/QScintilla-2.10.4/QScintilla_gpl-2.10.4.tar.gz"
  sha256 "0353e694a67081e2ecdd7c80e1a848cf79a36dbba78b2afa36009482149b022d"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "8bbfff0aeac4f664c6e1dcbbe9e2cdbd0412dab35366c2c1655decca65a59cb9" => :mojave
    sha256 "611ef06006ba219fda3bc109945c81c09370aa75624a49ec8ef17b8cf97a83c5" => :high_sierra
    sha256 "05d240624ec9baedc25779aa72ced9d605e3a351b2937830975f363ebc7f5c5b" => :sierra
  end

  depends_on "pyqt"
  depends_on "python"
  depends_on "python@2"
  depends_on "qt"
  depends_on "sip"

  def install
    spec = ENV.compiler == :clang ? "macx-clang" : "macx-g++"
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
