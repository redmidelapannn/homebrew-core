class Libqglviewer < Formula
  desc "C++ Qt library to create OpenGL 3D viewers"
  homepage "http://www.libqglviewer.com/"
  url "http://www.libqglviewer.com/src/libQGLViewer-2.6.3.tar.gz"
  sha256 "be611b87bdb8ba794a4d18eaed87f22491ebe198d664359829233c4ea69f4d02"
  head "https://github.com/GillesDebunne/libQGLViewer.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "323d6b2bb95797bf01c8c4fafa61e3bdc89de7320f14c9bded7349d24bf70afa" => :sierra
    sha256 "9558d99ff53c42ff841dc04bdd4914ff4e15e909fc5f12fef77519daa68b5451" => :el_capitan
    sha256 "ead95a70ae439e64e19ce69f55909e8de0ce174d37e6edb3f438eeca0064138e" => :yosemite
  end

  option :universal

  depends_on "qt5"

  def install
    args = %W[
      PREFIX=#{prefix}
      DOC_DIR=#{doc}
    ]
    args << "CONFIG += x86 x86_64" if build.universal?

    cd "QGLViewer" do
      system "qmake", *args
      system "make", "install"
    end
  end
end
