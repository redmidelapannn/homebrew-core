class Bs1770gain < Formula
  desc "Loudness scanner compliant with ITU-R BS.1770 and ReplayGain 2.0"
  homepage "https://bs1770gain.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bs1770gain/bs1770gain/0.5.1/bs1770gain-0.5.1.tar.gz"
  sha256 "06749f866417e6bcdb9fb24883cb08ae54248333a532380c7ddc56f7a45a8e64"

  bottle do
    cellar :any
    sha256 "5a6bd53bffb19a0f2bb0e6bd6a381495f62c350c0b0a19cb0295208969f5613f" => :mojave
    sha256 "dd043544c9accaed64cb08095ce537530efc949e52d61543e80655bcde99f418" => :high_sierra
    sha256 "627946bceb69f4a47f80013d1bef67f8e1a88c88181e0bd03115bf482057d136" => :sierra
  end

  depends_on "ffmpeg"
  depends_on "sox"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bs1770gain", "-h"
  end
end
