class Pmccabe < Formula
  desc "Calculate McCabe-style cyclomatic complexity for C/C++ code"
  homepage "https://packages.debian.org/sid/pmccabe"
  url "https://deb.debian.org/debian/pool/main/p/pmccabe/pmccabe_2.6.tar.gz"
  sha256 "e490fe7c9368fec3613326265dd44563dc47182d142f579a40eca0e5d20a7028"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "91619989c38fd57402e0b92bbb652181bffc9cd3aa818561440f911bfdcf86ac" => :mojave
    sha256 "f377f080119d3226504a098dea1cc804ab40b134e4fd467950d67d77c64e565c" => :high_sierra
    sha256 "1a7085b6a2e17e01cca81e6aabe58a2491b1ba7a4541206da9bc5dfc99fd7ef6" => :sierra
  end

  def install
    ENV.append_to_cflags "-D__unix"

    system "make"
    bin.install "pmccabe", "codechanges", "decomment", "vifn"
    man1.install Dir["*.1"]
  end

  test do
    assert_match /pmccabe #{version}/, shell_output("#{bin}/pmccabe -V")
  end
end
