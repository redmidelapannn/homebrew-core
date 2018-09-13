class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.5.tar.gz"
  sha256 "324b7bddedea13cebab0bc0fe9f8d5cfb7bfaf26eac5aa3aae1e74afa909aa12"
  head "https://github.com/mit-nlp/MITIE.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8833cdc7cf82f45026360e08de443c57e814049e42e714dc2346e4726154ef55" => :mojave
    sha256 "f30881de00e68998cb6c3dabc1859e85f9c6009a7707f7c18ea5a24aea9b040f" => :high_sierra
    sha256 "cc93603db605bb8e528f730f4fbbab5f2a767cf4215b756430b37cea0fe6acf4" => :sierra
    sha256 "ec475d8843e636ec2bc9773c7995a13165220dc88fa01380484777b20adfd2dc" => :el_capitan
  end

  depends_on "python@2"

  resource "models-english" do
    url "https://downloads.sourceforge.net/project/mitie/binaries/MITIE-models-v0.2.tar.bz2"
    sha256 "dc073eaef980e65d68d18c7193d94b9b727beb254a0c2978f39918f158d91b31"
  end

  def install
    (share/"MITIE-models").install resource("models-english")

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
