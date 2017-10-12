class HdtCpp < Formula
  desc "HDT C++ Library and Tools"
  homepage "https://github.com/rdfhdt/hdt-cpp"
  url "https://github.com/rdfhdt/hdt-cpp/archive/v1.2.0.tar.gz"
  sha256 "5eff3ba15839bfba7b3c15c35ea62c4352e0ad58cca1a1cd93d9f82c1eeed4dc"

  bottle do
    cellar :any
    sha256 "433083acf34dba68ac3e0399bbdefdd6a9350b6ffe46776eea86fde5a0033638" => :high_sierra
    sha256 "07bd34b562fdf28bb9a0c57d6ac6fe58cf4064716457ced52c36e99d12b4560a" => :sierra
    sha256 "26e140ec97c89eccb20fc2f2cb2b2ff0f7eb2baa8cd49fe063ce5f2883a856e3" => :el_capitan
  end

  depends_on "kyoto-cabinet"
  depends_on "serd"
  depends_on "qt"
  depends_on "raptor"

  def install
    inreplace "hdt-lib/qmake/hdt-lib.pro" do |s|
      # if you wanna build a dynamic lib instead
      # s.gsub! /staticlib/, "dll"
      s.gsub! /DEFINES \+=/, "DEFINES += HAVE_RAPTOR"
    end
    inreplace "hdt-lib/qmake/tools/tools.pri", /unix\:LIBS \+=/, "unix:LIBS += -lz -lserd-0"
    inreplace "hdt-it/hdt-it.pro", /unix\:LIBS \+=/, "unix:LIBS += -lraptor2"

    cd "libcds-v1.0.12/qmake" do
      system "qmake", "libcds.pro"
      system "make"
    end
    cd "hdt-lib/qmake" do
      system "qmake", "hdt-lib.pro"
      system "make"
    end
    cd "hdt-it" do
      system "qmake", "hdt-it.pro"
      system "make"
    end
    cd "hdt-lib/qmake/tools" do
      system "qmake", "tools.pro"
      system "make"
    end
    lib.install "./hdt-lib/qmake/macx/libhdt.a"
    include.install "./hdt-lib/include"
    bin.install "./hdt-lib/qmake/tools/hdtsearch/hdtsearch"
    bin.install "./hdt-lib/qmake/tools/rdf2hdt/rdf2hdt"
    # don't install the .app because brew complains
    # bin.install "./hdt-it/macx/HDT-it.app"
  end

  test do
    system "#{bin}/rdf2hdt", "--version"
  end
end
