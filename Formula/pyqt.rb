class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://www.riverbankcomputing.com/static/Downloads/PyQt5/5.13.2/PyQt5-5.13.2.tar.gz"
  sha256 "adc17c077bf233987b8e43ada87d1e0deca9bd71a13e5fd5fc377482ed69c827"

  bottle do
    cellar :any
    sha256 "6512ec72d61937d6e254ba93843886361b775c4717ea6370e31e9b807226dd2d" => :mojave
  end

  depends_on "python"
  depends_on "qt"
  depends_on "sip"

  def install
    version = Language::Python.major_minor_version "python3"
    args = ["--confirm-license",
            "--bindir=#{bin}",
            "--destdir=#{lib}/python#{version}/site-packages",
            "--stubsdir=#{lib}/python#{version}/site-packages/PyQt5",
            "--sipdir=#{share}/sip/Qt5",
            # sip.h could not be found automatically
            "--sip-incdir=#{Formula["sip"].opt_include}",
            "--qmake=#{Formula["qt"].bin}/qmake",
            # Force deployment target to avoid libc++ issues
            "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
            "--qml-plugindir=#{pkgshare}/plugins",
            "--verbose"]

    system "python3", "configure.py", *args
    system "make"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system "#{bin}/pyuic5", "--version"
    system "#{bin}/pylupdate5", "-version"

    system "python3", "-c", "import PyQt5"
    %w[
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system "python3", "-c", "import PyQt5.Qt#{mod}" }
  end
end
