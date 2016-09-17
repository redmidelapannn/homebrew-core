class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "http://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "http://mirror.httrack.com/historical/httrack-3.48.21.tar.gz"
  sha256 "871b60a1e22d7ac217e4e14ad4d562fbad5df7c370e845f1ecf5c0e4917be482"

  bottle do
    rebuild 2
    sha256 "b292a98716b103d2a718fee4a6994980b361e863cbc40a0f49b41e91ffc79162" => :el_capitan
    sha256 "0ae178de121c2678a2aa5f8d9e3244b8fc92d5b2829dcc255daa077d865bb9d1" => :yosemite
    sha256 "ad4c21c0089ae407c3ee77852a30ac1ab467fcadcc8c10d96e95db2d3933b75b" => :mavericks
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_rf Dir["#{share}/{applications,pixmaps}"]
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert File.exist?("raw.githubusercontent.com")
  end
end
