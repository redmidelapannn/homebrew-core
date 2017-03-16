class Fairymax < Formula
  desc "AI for playing Chess variants"
  homepage "https://www.chessvariants.com/index/msdisplay.php?itemid=MSfairy-max"
  url "http://hgm.nubati.net/git/fairymax.git", :tag => "4.8V", :revision => "b12e1192005c781f64ed9c25c9825d20384d2468"
  version "4.8V"
  head "http://hgm.nubati.net/git/fairymax.git"

  bottle do
    rebuild 1
    sha256 "52493593fa07c1603cacfc8742b9684996c37dffbcbdf987fbe164b092ced623" => :sierra
    sha256 "e5db7efabe3ca24d27ccec1cd033380dcea7ad363d6bdd80f96b0cb42fe450d8" => :el_capitan
    sha256 "4cda5caafbafea08cb92f01923482570ab083c6499f8585e7befc601f7e27127" => :yosemite
  end

  def install
    system "make", "all",
                   "INI_F=#{pkgshare}/fmax.ini",
                   "INI_Q=#{pkgshare}/qmax.ini"
    bin.install "fairymax", "shamax", "maxqi"
    pkgshare.install Dir["data/*.ini"]
    man6.install "fairymax.6.gz"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      hint
      quit
    EOS
    system "#{bin}/fairymax < test"
  end
end
