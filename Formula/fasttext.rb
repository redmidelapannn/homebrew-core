class Fasttext < Formula
  desc "Library for fast text representation and classification"
  homepage "https://github.com/facebookresearch/fastText"
  url "https://github.com/facebookresearch/fastText/archive/v0.1.0.tar.gz"
  sha256 "d6b4932b18d2c8b3d50905028671aadcd212b7aa31cbc6dd6cac66db2eff1397"
  head "https://github.com/facebookresearch/fastText.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "274a78c4f4cc2438351c22d688969150b2294104a636d0e27cb0d2c03e05e4d3" => :high_sierra
    sha256 "eac4c0ea81c7a9898457d54b1498b9ea79d5de7ee28bacb8bb1f3adeb89980c3" => :sierra
    sha256 "4e3bd4260d8b284c6c0af34a26b3819e41ff0b42fd107e792927a735ed28ab3d" => :el_capitan
  end

  def install
    system "make"
    bin.install "fasttext"
  end

  test do
    system "true"
  end
end
