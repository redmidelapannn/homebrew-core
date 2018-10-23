class Sng < Formula
  desc "Enable lossless editing of PNGs via a textual representation"
  homepage "https://sng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sng/sng-1.1.0.tar.gz"
  sha256 "119c55870c1d1bdc65f7de9dbc62929ccb0c301c2fb79f77df63f5d477f34619"
  bottle do
    sha256 "ab8d862469ef4a68173370999ede8655b6b2029aa0961a9d6002507fcb42ae86" => :mojave
    sha256 "8c2379e942131759a77b6215d38b9e69d288f00642db828c5a8377f3f3376f85" => :high_sierra
    sha256 "7efe7a36a5b16e53f8242c269c31e047875c84a2c0317d17c46ad1506547f236" => :sierra
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=/usr/local/Cellar/sng/1.1.0"
    system "make", "install"
  end

  test do
    system("curl -o $HOME/test.png 'https://upload.wikimedia.org/wikipedia/en/2/2c/WikiPNGRenderingTestB_Thumb_RGB.png'")
    system("$bin/sng $HOME/test.png")
  end
end
