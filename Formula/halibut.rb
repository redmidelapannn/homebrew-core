class Halibut < Formula
  desc "Yet another free document preparation system"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/halibut/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.1.tar.gz"
  sha256 "b964950d11ed09d3af28ac095da539613f6e50d650f01fe72b4ae752724c80a0"

  head "https://git.tartarus.org/simon/halibut.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6975b4502ff70c56fec6df8f219ffea3403ede9ff73883ccc702631b541739a0" => :sierra
    sha256 "4b7172187a3ae293c12daef94bc7395c0e5cbc2a5b27f4fcef05ea8dbb544ea8" => :el_capitan
    sha256 "1e9905e37b0ecd10cf0b24de62a764c500c40f302b83443166eafa88d9e70c3b" => :yosemite
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
