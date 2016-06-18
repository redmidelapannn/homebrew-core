class Platypus < Formula
  desc "Create OS X applications from {Perl,Ruby,sh,Python} scripts"
  homepage "http://sveinbjorn.org/platypus"
  url "http://sveinbjorn.org/files/software/platypus/platypus5.1.src.zip"
  version "5.1"
  sha256 "7ff3a5e7c5a01603855e3294763d5603b90f8cfa100670771abc1097fd85fc7a"
  head "https://github.com/sveinbjornt/Platypus.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c4f5b5879db741a064cb3efa0310654614aaa29419811b3c9cbbb497411130ee" => :el_capitan
    sha256 "c29acc3348405ece22e0870bcc5b339dce57377bd2fa86f64f69c0dd824a0318" => :yosemite
  end

  depends_on :xcode => ["7.0", :build]

  def install
    xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}",
               "-project", "Platypus.xcodeproj",
               "-target", "platypus",
               "-target", "ScriptExec",
               "clean",
               "install"

    man1.install "CommandLineTool/man/platypus.1"

    cd buildpath

    bin.install "platypus_clt" => "platypus"

    cd "build/UninstalledProducts/macosx/ScriptExec.app/Contents" do
      pkgshare.install "Resources/MainMenu.nib", "MacOS/ScriptExec"
    end
  end

  def caveats; <<-EOS.undent
    This formula only installs the command-line Platypus tool, not the GUI.

    The GUI can be downloaded from Platypus' website:
      http://sveinbjorn.org/platypus

    Alternatively, install with Homebrew-Cask:
      brew cask install platypus
    EOS
  end

  test do
    system "#{bin}/platypus", "-v"
  end
end
