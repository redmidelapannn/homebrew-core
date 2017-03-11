class Halibut < Formula
  desc "Yet another free document preparation system"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/halibut/"
  url "http://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.1.tar.gz"
  sha256 "b964950d11ed09d3af28ac095da539613f6e50d650f01fe72b4ae752724c80a0"

  head "https://git.tartarus.org/simon/halibut.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e38224e488d56fa0bd25fea083d81caba341c932035489cd6b2f396d7adf42a3" => :sierra
    sha256 "daec72e39d6c4d505b65b514d1abaeaece8d9f526696f3040cb7b3db82c85cfa" => :el_capitan
    sha256 "aa6d9c0e32142993e9395155f181236ac306bab2ccf5cbf56533659fa9341757" => :yosemite
  end

  def install
    # Reported to Simon Tatham (anakin@pobox.com) on 8th Mar 2016.
    ENV.deparallelize

    bin.mkpath
    man1.mkpath

    system "make", "prefix=#{prefix}", "mandir=#{man}", "all"
    system "make", "-C", "doc", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    (testpath/"sample.but").write("Hello, world!")
    system "#{bin}/halibut", "--html=sample.html", "sample.but"

    assert_match("<p>\nHello, world!\n<\/p>",
                 (testpath/"sample.html").read)
  end
end
