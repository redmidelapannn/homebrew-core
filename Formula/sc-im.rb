class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.5.0.tar.gz"
  sha256 "d7a31c5225e02239e925b50b414d7e69d12bc3554f218621823782872ccc5e4d"
  head "https://github.com/andmarti1424/sc-im.git", :branch => "freeze"

  bottle do
    sha256 "153d3b44c6a3863de5bcf73faf129ee66d0e2eeeb611542894c63806e964cf3d" => :sierra
    sha256 "256ddb763bc368540e4f4902e36e43a4f165df94e28937f5ef34380eeafe9461" => :el_capitan
    sha256 "8a97f65f1c063d713e5d9e5a08ee3e3792e88714afeb0e27fded428f0380dd8b" => :yosemite
  end

  depends_on "ncurses"

  def install
    cd "src" do
      system "make", "prefix=#{prefix}", "LDFLAGS=-L#{Formula["ncurses"].lib}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    system "#{bin}/scim", "--nocurses", "--quit_afterload"
  end
end
