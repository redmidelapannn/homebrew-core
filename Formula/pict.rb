class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/master.zip"
  version "33"
  sha256 "73d36bc93d72dfbc936e11774c5615b23689cab1a3507995dcb9266d406f5e11"

  bottle do
    cellar :any_skip_relocation
    sha256 "e46de6c979d7740afc6181fa1a836c422e54b41051a77561aa4dc16bc6e4a780" => :high_sierra
    sha256 "ab476c261c4dd34327b17fbf33d5882abac72559f4f1a99055acaa7efc1bace8" => :sierra
  end

  def install
    system "make"
    bin.mkpath
    bin.install "pict"
  end

  test do
    system "#{bin}/pict"
  end
end
