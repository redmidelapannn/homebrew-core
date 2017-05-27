class Ect < Formula
  desc "File and image optimizer. It supports PNG, JPEG, GZIP and ZIP files."
  homepage "https://github.com/fhanau/Efficient-Compression-Tool#readme"
  url "https://github.com/fhanau/Efficient-Compression-Tool/archive/0.7.tar.gz"
  sha256 "e117bc274e91de38eee11fef89e65c397962ffb9d500851061d9745924e77cd1"
  head "https://github.com/fhanau/Efficient-Compression-Tool.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "edaedcf7185a7789d6964eec1980919ab3dbc5f194f584afcba9721bd968d70e" => :sierra
    sha256 "7cc51059c1c3f93b1578442962af1d5880733b6429b21c02dd47becd67f48b04" => :el_capitan
    sha256 "ccc9b5b2343cdd6606f82dfada6faa6acf0edab7b5d811e23f16b6bd0709f2e4" => :yosemite
  end

  depends_on "nasm" => :build

  def install
    ENV.deparallelize
    cd "src" do
      system "make"
    end

    bin.install "ECT"
  end

  test do
    system "#{bin}/ECT", test_fixtures("test.png")
  end
end
