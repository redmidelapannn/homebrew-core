class Vcs < Formula
  desc "Creates video contact sheets (previews) of videos."
  homepage "https://p.outlyer.net/vcs/"
  url "https://p.outlyer.net/vcs/files/vcs-1.13.2.tar.gz"
  sha256 "fc2a2b3994d5ffb5d87fb3dceaa5f6855aca7a89c58533b12fd11b8fb5b623af"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "09089634879454d656c659713a6b3439b6e2cbe0bf9939a2dd0e141b8fe97ed5" => :sierra
    sha256 "473f24d6d7cfa2b0130eab1f07e3c364a79d73f6a565d011dc3f5afb6a2cb033" => :el_capitan
    sha256 "473f24d6d7cfa2b0130eab1f07e3c364a79d73f6a565d011dc3f5afb6a2cb033" => :yosemite
  end

  depends_on "ffmpeg"
  depends_on "gnu-getopt"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "mplayer" => :optional

  def install
    inreplace "vcs", "declare GETOPT=getopt", "declare GETOPT=#{Formula["gnu-getopt"].opt_bin}/getopt"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system Formula["ffmpeg"].bin/"ffmpeg", "-f", "rawvideo", "-s", "hd720",
           "-pix_fmt", "yuv420p", "-r", "30", "-t", "5", "-i", "/dev/zero",
           testpath/"video.mp4"
    assert (testpath/"video.mp4").exist?

    system bin/"vcs", "-i", "1", "-o", testpath/"sheet.png", testpath/"video.mp4"
    assert (testpath/"sheet.png").exist?
  end
end
