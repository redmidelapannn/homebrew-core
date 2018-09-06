class Dtrx < Formula
  desc "Intelligent archive extraction"
  homepage "https://brettcsmith.org/2007/dtrx/"
  url "https://brettcsmith.org/2007/dtrx/dtrx-7.1.tar.gz"
  sha256 "1c9afe48e9d9d4a1caa4c9b0c50593c6fe427942716ce717d81bae7f8425ce97"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d16673208b99eaed63c9a8e2351dca8c5781f9d6f68c633820a3740c42ed916b" => :mojave
    sha256 "e14054b4de1d404f817ba46b6c80ae3c737f01e3db81a7622fdcebb3d09dbef4" => :high_sierra
    sha256 "e14054b4de1d404f817ba46b6c80ae3c737f01e3db81a7622fdcebb3d09dbef4" => :sierra
    sha256 "e14054b4de1d404f817ba46b6c80ae3c737f01e3db81a7622fdcebb3d09dbef4" => :el_capitan
  end

  depends_on "p7zip"
  depends_on "unrar"

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/dtrx", "--version"
  end
end
