class Sifu < Formula
  desc "Rapid software development tool made for creating cloud solutions."
  homepage "https://codesifu.com"
  url "https://codesifu.com/download/sifu-0.1.1.tar.gz"
  sha256 "d0ef00a475766bf4717b4721044bdbd0f1c8c02be3a1f824738d306b08a06cd2"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dca221c8e34a414c8d00b67639f2c579876bf3eff96033a9d33be1ec520e003" => :el_capitan
    sha256 "2af9f9fe15d6aab7fd57ee8e4213dcb71c8066130dd992dcf3422a6c2c90a16a" => :yosemite
    sha256 "2af9f9fe15d6aab7fd57ee8e4213dcb71c8066130dd992dcf3422a6c2c90a16a" => :mavericks
  end

  depends_on :java

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]

    bin.write_exec_script libexec/"sifu"
  end

  test do
    system "#{bin}/sifu", "--help"
  end
end
