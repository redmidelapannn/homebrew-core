class Platypus < Formula
  desc "Create macOS applications from {Perl,Ruby,sh,Python} scripts"
  homepage "https://sveinbjorn.org/platypus"
  url "https://sveinbjorn.org/files/software/platypus/platypus5.2.src.zip"
  sha256 "0c0201804e13c09a33fe95ba715ed995872d35d3cdfa2cb694cf378980ed4c08"
  head "https://github.com/sveinbjornt/Platypus.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2a582a40f1e1f038be24448a373d4b3c3df7c951f6ec10b21ada09b736ba711f" => :high_sierra
    sha256 "8e627729c8f29444575db7274b83bf4d54f23281bb6b4d368c4bb2eb535243c4" => :sierra
    sha256 "dacb448f19e8bd1f339f3549e4436713aba4e75757c9607f71cc467c360ef55a" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}",
               "-project", "Platypus.xcodeproj",
               "-target", "platypus",
               "-target", "ScriptExec",
               "clean",
               "install"

    man1.install "CommandLineTool/man/platypus.1"
    bin.install "platypus_clt" => "platypus"

    cd "build/UninstalledProducts/macosx/ScriptExec.app/Contents" do
      pkgshare.install "Resources/MainMenu.nib", "MacOS/ScriptExec"
    end
  end

  def caveats; <<~EOS
    This formula only installs the command-line Platypus tool, not the GUI.

    The GUI can be downloaded from Platypus' website:
      https://sveinbjorn.org/platypus

    Alternatively, install with Homebrew-Cask:
      brew cask install platypus
  EOS
  end

  test do
    system "#{bin}/platypus", "-v"
  end
end
