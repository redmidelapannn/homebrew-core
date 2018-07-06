class CsvLocalizer < Formula
  desc "Convert CSV file to iOS and Android localizable strings"
  homepage "https://github.com/rogermolas/csv-localizer"
  url "https://github.com/rogermolas/csv-localizer/archive/v1.2.1.tar.gz"
  sha256 "9ed12ed932673521659bee64edb9ff727c845a3a948aac00a3354b5f96a825e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9066e8de986bcc6f4e873c2d61a6d394a2bacc3d36fc86d0371f7daddfbc49e4" => :high_sierra
    sha256 "9066e8de986bcc6f4e873c2d61a6d394a2bacc3d36fc86d0371f7daddfbc49e4" => :el_capitan
  end

  depends_on "python@2"

  def install
    bin.install "csv-localizer"
  end

  test do
    system "#{bin}/csv-localizer", "-h"
  end
end
