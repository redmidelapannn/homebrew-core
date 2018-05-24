class Soundpipe < Formula
  desc "Lightweight music DSP library"
  homepage "https://paulbatchelor.github.io/proj/soundpipe.html"
  url "https://github.com/PaulBatchelor/soundpipe/archive/v1.7.0.tar.gz"
  sha256 "2d6f6b155ad93d12f59ae30e2b0f95dceed27e0723147991da6defc6d65eadda"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2cd5cad64cf80a40b55f8763245db607ee1362f78ddb097c21481f407c2b75c5" => :high_sierra
    sha256 "2ae5365c6f886f97684b44ad85c2e260af33427a826bdc4330216f06f70f3317" => :sierra
    sha256 "118ac74143825ef92e186317118baa7362888409139823b59389149bd170e60c" => :el_capitan
  end

  depends_on "libsndfile"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples", "test"
  end

  test do
    system ENV.cc, "#{pkgshare}/examples/ex_osc.c", "-o", "test", "-L#{lib}",
                   "-L#{lib}", "-lsndfile", "-lsoundpipe"
    system "./test"
    assert_predicate testpath/"test.wav", :exist?
  end
end
