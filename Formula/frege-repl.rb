class FregeRepl < Formula
  desc "REPL (read-eval-print loop) for Frege"
  homepage "https://github.com/Frege/frege-repl"
  url "https://github.com/Frege/frege-repl/releases/download/1.4-SNAPSHOT/frege-repl-1.4-SNAPSHOT.zip"
  version "1.4-SNAPSHOT"
  sha256 "2cf1c2a8f7b64c9d70b21fbfd25b2af3f5e3bebe3662f724afd435d01bddafec"

  bottle do
    cellar :any_skip_relocation
    sha256 "9829555e726cc323a49348d3978012b5fbe3d2ff94f893b218fa85e2339efe3d" => :el_capitan
    sha256 "07189a54129e001f0a2b289ef9ac340ed193d511e475aa4164175db47ac6074b" => :yosemite
    sha256 "6df29fe763e09a1f57f7f101a7007351c0991cf68d5d19acc10b7a929a5018a4" => :mavericks
  end

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install "bin", "lib"
    bin.install_symlink "#{libexec}/bin/frege-repl"
  end

  test do
    assert_match "65536", pipe_output("#{bin}/frege-repl", "println $ 64*1024\n:quit\n")
  end
end
