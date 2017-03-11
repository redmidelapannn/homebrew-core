class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-1.31.tar.gz"
  mirror "https://downloads.sourceforge.net/project/flawfinder/flawfinder-1.31.tar.gz"
  sha256 "bca7256fdf71d778eb59c9d61fc22b95792b997cc632b222baf79cfc04887c30"

  head "https://git.code.sf.net/p/flawfinder/code.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "65a54ea290ac0f663668349dc455570213317e00fe8789b838138c02cacec186" => :sierra
    sha256 "65a54ea290ac0f663668349dc455570213317e00fe8789b838138c02cacec186" => :el_capitan
    sha256 "65a54ea290ac0f663668349dc455570213317e00fe8789b838138c02cacec186" => :yosemite
  end

  resource "flaws" do
    url "https://www.dwheeler.com/flawfinder/test.c"
    sha256 "4a9687a091b87eed864d3e35a864146a85a3467eb2ae0800a72e330496f0aec3"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("flaws").stage do
      assert_match "Hits = 36",
                   shell_output("#{bin}/flawfinder test.c")
    end
  end
end
