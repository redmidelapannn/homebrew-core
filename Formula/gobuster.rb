class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster.git",
      :tag      => "v3.0.1",
      :revision => "9ef3642d170d71fd79093c0aa0c23b6f2a4c1c64"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b768940ae374db6ae1674e231f75769ac932550a80c5904d6556a7597acc4b21" => :mojave
    sha256 "33f90d97ea25a3a62bce376315c19c52a8a0d5c98d1c544ff1bf4524d50482f9" => :high_sierra
    sha256 "96ca3d0c828f92e92cb2e3a19a92f6c84464edffea44a0ee5765ffea82eb55e1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/OJ/gobuster"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"gobuster"
      prefix.install_metafiles
    end
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
