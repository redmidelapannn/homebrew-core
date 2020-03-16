class Hmm < Formula
  desc "Command-line note taking app written in Rust"
  homepage "https://github.com/samwho/hmm"
  url "https://github.com/samwho/hmm/archive/v0.2.tar.gz"
  sha256 "4e2d474d2eb70f313ef6a97a5f392310e0317be9f7d88d46ddf5fe9b9e6a1910"
  head "https://github.com/samwho/hmm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad5aaa87bd8721afc264650df2f6e5c9b81e6f55c7b925162d0bf107d3474c92" => :catalina
    sha256 "b0142696b1619a1b0797baf8124792275f90872acf172f41cd3c8f7d82ef9f61" => :mojave
    sha256 "35b7de025386953caac20ae899bfa53008cfcea621750b877ac932d3e4dec51f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "", shell_output("#{bin}/hmm hello world")
    assert_equal "hello world\n", shell_output("#{bin}/hmmq --format \"{{ message }}\"")
  end
end
