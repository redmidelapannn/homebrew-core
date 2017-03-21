class Ecm < Formula
  desc "Prepare CD image files so they compress better"
  homepage "https://web.archive.org/web/20140227165748/www.neillcorlett.com/ecm/"
  url "https://web.archive.org/web/20091021035854/www.neillcorlett.com/downloads/ecm100.zip"
  version "1.0"
  sha256 "1d0d19666f46d9a2fc7e534f52475e80a274e93bdd3c010a75fe833f8188b425"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1bcca7f66137a1e90005ad3cb515fe7762e2eca1f1f661a54a98f5188f6410fc" => :sierra
    sha256 "58586268193e790a0b8dd577cb24c5bf93a5e89010ec2fec17e96f3217cb64bb" => :el_capitan
    sha256 "43f5d914543fe0e95717a0427d0411d5c9c920654c9e471cb107aec15bf51c67" => :yosemite
  end

  def install
    system ENV.cc, "-o", "ecm", "ecm.c"
    system ENV.cc, "-o", "unecm", "unecm.c"
    bin.install "ecm", "unecm"
  end
end
