class RandomizeLines < Formula
  desc "Reads and randomize lines from a file (or STDIN)"
  homepage "https://arthurdejong.org/rl/"
  url "https://arthurdejong.org/rl/rl-0.2.7.tar.gz"
  sha256 "1cfca23d6a14acd190c5a6261923757d20cb94861c9b2066991ec7a7cae33bc8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "98bd82aee4566802104a0950bb5599ed850d7031f04573b89bcc04b21643a0f1" => :catalina
    sha256 "d6433a7480470883c1e049b659fdd88a0943f1190044d97a92b92d7f12853693" => :mojave
    sha256 "5e07e6810ff9f62b2af92fba8e4c3ce05a0df1803036016c0becf76886c4118c" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system system "echo", "-e", "\" ""1\n2\n4\" | \"#{bin}/rl\" -c 1"
  end
end
