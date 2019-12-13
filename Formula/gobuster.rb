class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster.git",
      :tag      => "v3.0.1",
      :revision => "9ef3642d170d71fd79093c0aa0c23b6f2a4c1c64"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4c8f7838d25aa09d1a9487c6f70c8d15058fdd41008ae895082f8891a0798b0" => :catalina
    sha256 "a9c4bbe39fb195053b3ab6775df8a70e23db510b4a04193b87bde9a82ed512d2" => :mojave
    sha256 "1509160d7934a4d2ae01fba76441e905bd1fc36687d58a557ebaf7b47c274e30" => :high_sierra
    sha256 "d72c5733c19364971ad6b6445b5c0c591bceffb6340ecbbb35c44295e1e04ff7" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"gobuster"
    prefix.install_metafiles
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output
  end
end
