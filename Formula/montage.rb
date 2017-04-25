class Montage < Formula
  desc "Toolkit for assembling FITS images into custom mosaics"
  homepage "http://montage.ipac.caltech.edu"
  url "http://montage.ipac.caltech.edu/download/Montage_v5.0.tar.gz"
  sha256 "72e034adb77c8a05ac40daf9d1923c66e94faa0b08d3d441256d9058fbc2aa34"

  bottle do
    cellar :any_skip_relocation
    sha256 "14833a3475d3ca1b9d626f58df7a8be5b6e82debd28152474349d5606e9b0be4" => :sierra
    sha256 "878785043f573677fc9c11f34d26aee767d6782539b4a11195b0c423a6e3cae0" => :el_capitan
    sha256 "2fa3e4e581af9a52f6334add2ed0af59d1fe6a75656697855ad8463d68a11d42" => :yosemite
  end

  conflicts_with "wdiff", :because => "Both install an mdiff executable"

  def install
    # Reported upstream: https://github.com/Caltech-IPAC/Montage/issues/19
    ENV.deparallelize
    system "make"
    bin.install Dir["bin/m*"]
  end

  def caveats; <<-EOS.undent
    Montage is under the Caltech/JPL non-exclusive, non-commercial software
    licence agreement available at:
      http://montage.ipac.caltech.edu/docs/download.html
    EOS
  end

  test do
    system bin/"mHdr", "m31", "1", "template.hdr"
  end
end
