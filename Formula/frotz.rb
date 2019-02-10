class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://github.com/DavidGriffith/frotz"
  url "https://github.com/DavidGriffith/frotz/archive/2.44.tar.gz"
  sha256 "dbb5eb3bc95275dcb984c4bdbaea58bc1f1b085b20092ce6e86d9f0bf3ba858f"
  head "https://github.com/DavidGriffith/frotz.git"

  bottle do
    rebuild 1
    sha256 "86773dfacbf1d068913e79b587758d45ec9aafdde642b62855469799d497a086" => :mojave
    sha256 "4995e58d8c8c8ac66ec8683004d4ae330dd7c1a4e1514cef940ad735bf57fdc7" => :high_sierra
    sha256 "696d64424430efab63211d9dc267719aa2a283b03cc4894cf81ca5b18fc9db5f" => :sierra
  end

  resource "testdata" do
    url "https://github.com/anag004/FrotzTestFile/blob/master/test.z5?raw=true"
    sha256 "40263585821ca3784afd07cf31492e23e7803aeb83d38b177a2019a95892dda8"
  end

  def install
    inreplace "Makefile" do |s|
      s.remove_make_var! %w[CC OPTS]
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "CONFIG_DIR", etc
      s.change_make_var! "MAN_PREFIX", share
    end

    system "make", "frotz"
    system "make", "install"
  end

  test do
    resource("testdata").stage testpath
    system "echo test | frotz #{testpath}/testdata"
  end
end
