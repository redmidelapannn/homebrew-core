class Ospac < Formula
  desc "Open Source Podcast Audio Chain"
  homepage "http://ospac.net/"
  url "https://github.com/sritterbusch/ospac/archive/v1.0.tar.gz"
  sha256 "793f0454cebe48dfa8364f26fa48469717954c31cb632a9c0b9dd24920d83f4c"

  bottle do
    cellar :any
    sha256 "5d9f136dda5009e61ff5ba4cb9ed127648f7e1b03392e923993e5f5daf43545e" => :el_capitan
    sha256 "5a7842cf8bae7de76e09e9d0035425198697362abfad19a905ce58706b9901a9" => :yosemite
    sha256 "f02b187b06d7eb53769be66e3a5e73f8801133070c312f4adee0cf3430b0972f" => :mavericks
  end

  depends_on "libsndfile"

  def install
    inreplace "makefile.targets", "/usr/local", prefix.to_s
    mkdir bin.to_s
    mkdir share.to_s
    mkdir man.to_s
    mkdir man1.to_s
    system "make", "ospac", "install"
  end

  test do
    system "ospac", "--help"
  end
end
