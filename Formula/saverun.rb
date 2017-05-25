
class Saverun < Formula
  desc "Run your program on save automatically"
  homepage "https://github.com/MenkeTechnologies/SaveRun"
  url "https://github.com/MenkeTechnologies/SaveRun/archive/v1.0.3.tar.gz"
  sha256 "ce205b60018cbbc216a90bcaa66cea3db969d3a766449dbb23fd63ed9721dc2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dd228cb45b49947527f05d6ea511dc7f2f9446a1ce9feb78747bdf53c293699" => :sierra
    sha256 "b0fae78ea06e4ad5dca64aa29f71adf5c47305c95398447a32a0f4636dcfd3ef" => :el_capitan
    sha256 "b0fae78ea06e4ad5dca64aa29f71adf5c47305c95398447a32a0f4636dcfd3ef" => :yosemite
  end

  depends_on "fswatch" => :run
  depends_on "bash" => :run

  def install
    bin.install "bin/save-interpret-run"
    bin.install "bin/save-compile-run"
  end

  test do
    system "save-interpret-run -h"
  end
end
