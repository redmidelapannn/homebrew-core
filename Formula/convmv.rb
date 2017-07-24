class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "https://www.j3e.de/linux/convmv/"
  url "https://www.j3e.de/linux/convmv/convmv-2.03.tar.gz"
  sha256 "f898fd850c8ef5abe48f7536e4b23ce4e11b6133974b2fc41d9197dfecc1c027"

  bottle do
    cellar :any_skip_relocation
    sha256 "e982afa59680fe00e13da653d2a73ab537f194d0ad0a5ec7953fab95e8e73963" => :sierra
    sha256 "f4451144243611e621226eb41d1838c2f7c18f97c5d2a973caeb151abcc0b808" => :el_capitan
    sha256 "53cc7e28953c5b2a7a935b430bc79a7eef32ad16c47a0a5e93e13f36b4d3f0fa" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/convmv", "--list"
  end
end
