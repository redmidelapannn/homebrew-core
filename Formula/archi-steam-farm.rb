class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.3.1.8/ASF.zip"
  version "2.3.1.8"
  sha256 "169a2f6deaf582646781089d301a03208cbbc127a9f924a5815ab9ba8707cb19"

  bottle do
    cellar :any_skip_relocation
    sha256 "a69731ba9c4484d7b96b99cba509c5c9a4a741e04f3ba04f9e37cfdc6144fc12" => :sierra
    sha256 "ef074be7e79ee01bd2e15e4da14922fcadd8a0823a90d2c3da7161539c578b0b" => :el_capitan
    sha256 "ef074be7e79ee01bd2e15e4da14922fcadd8a0823a90d2c3da7161539c578b0b" => :yosemite
  end

  depends_on "mono"

  def install
    libexec.install "ASF.exe"
    (bin/"asf").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/ASF.exe "$@"
    EOS

    etc.install "config" => "asf"
    libexec.install_symlink etc/"asf" => "config"
  end

  def caveats; <<-EOS.undent
    Config: #{etc}/asf/
    EOS
  end

  test do
    assert_match "ASF V#{version}", shell_output("#{bin}/asf --client")
  end
end
