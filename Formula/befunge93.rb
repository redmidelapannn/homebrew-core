class Befunge93 < Formula
  desc "Esoteric programming language"
  homepage "https://catseye.tc/node/Befunge-93.html"
  url "https://catseye.tc/distfiles/befunge-93-2.23-2015.0101.zip"
  version "2.23-2015.0101"
  sha256 "7ca6509b9d25627f90b9ff81da896a8ab54853e87a5be918d79cf425bcb8246e"
  head "https://github.com/catseye/Befunge-93.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d4065ac2ca8d3c21ee94406912a5ab59ad375f199b7338c641e435281968aa68" => :sierra
    sha256 "deae1407d43ed46cfa4c7c2c12870f9c211a9d1c8cb9e67d66d8d99aab22429a" => :el_capitan
    sha256 "dd346f6a6b5f1375dbd4b03b93e986faaa297db355105d6cb4a0180972ab256d" => :yosemite
  end

  def install
    system "make"
    bin.install Dir["bin/bef*"]
  end

  test do
    (testpath/"test.bf").write '"dlroW olleH" ,,,,,,,,,,, @'
    assert_match /Hello World/, shell_output("#{bin}/bef test.bf")
  end
end
