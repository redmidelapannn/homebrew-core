class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.5.tar.gz"
  sha256 "324b7bddedea13cebab0bc0fe9f8d5cfb7bfaf26eac5aa3aae1e74afa909aa12"

  head "https://github.com/mit-nlp/MITIE.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8ba36618952401aa6ed4a3e1f0e4c214efd53005e6f2ec59841fc79ea655ddea" => :high_sierra
    sha256 "0a8f81ad98a5f3254133b6c28eaf5881c3ed17261787780d2b9f721d2013d6eb" => :sierra
    sha256 "261e91b9fa8aeacfba91f5c1c8718fcb382cf195efb2767f84c5d75bb406b9ef" => :el_capitan
  end

  option "without-models", "Don't download the v0.2 models (~415MB)"

  depends_on "python@2"

  resource "models-english" do
    url "https://downloads.sourceforge.net/project/mitie/binaries/MITIE-models-v0.2.tar.bz2"
    sha256 "dc073eaef980e65d68d18c7193d94b9b727beb254a0c2978f39918f158d91b31"
  end

  def install
    if build.with? "models"
      (share/"MITIE-models").install resource("models-english")
    end

    inreplace "mitielib/makefile", "libmitie.so", "libmitie.dylib"
    system "make", "mitielib"
    system "make"

    include.install Dir["mitielib/include/*"]
    lib.install "mitielib/libmitie.dylib", "mitielib/libmitie.a"
    (lib/"python2.7/site-packages").install "mitielib/mitie.py"
    pkgshare.install "examples", "sample_text.txt",
      "sample_text.reference-output", "sample_text.reference-output-relations"
    bin.install "ner_example", "ner_stream", "relation_extraction_example"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lmitie",
           pkgshare/"examples/C/ner/ner_example.c",
           "-o", testpath/"ner_example"
    system "./ner_example", share/"MITIE-models/english/ner_model.dat",
           pkgshare/"sample_text.txt"
  end
end
