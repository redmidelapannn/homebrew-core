class Alac < Formula
  desc "Basic decoder for Apple Lossless Audio Codec files (ALAC)"
  homepage "https://web.archive.org/web/20150319040222/http://craz.net/programs/itunes/alac.html"
  url "https://web.archive.org/web/20150510210401/http://craz.net/programs/itunes/files/alac_decoder-0.2.0.tgz"
  sha256 "7f8f978a5619e6dfa03dc140994fd7255008d788af848ba6acf9cfbaa3e4122f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3c833c71834ea65498c761d4fe444a26e97e107433de526ab55ad1fb0d36a2ba" => :sierra
    sha256 "d1f97862121790377cc977c80df1d288f96376a4bc191f587e7141914a5b0290" => :el_capitan
    sha256 "2251067e67fd75265dfc81c60e4118887256320b4be805d7800f33ac44b08fb4" => :yosemite
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    bin.install "alac"
  end

  test do
    sample = test_fixtures("test.m4a")
    assert_equal "file type: mp4a\n", shell_output("#{bin}/alac -t #{sample}", 100)
  end
end
