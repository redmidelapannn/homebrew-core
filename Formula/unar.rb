class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://unarchiver.c3.cx/commandline"
  url "https://wakaba.c3.cx/releases/TheUnarchiver/unar1.10.1_src.zip"
  version "1.10.1"
  sha256 "40967014a505b7a27864c49dc3b5d30b98ae4e6d4873783b2ef9ef9215fd092b"

  head "https://bitbucket.org/WAHa_06x36/theunarchiver", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "23bc4af813df68bf21bedece9ee0f2b166bac146e42e4ec76a2b0b21ad9f67fa" => :high_sierra
    sha256 "2776cf2543db5d1fbae3ebf37228271d36c6e420a4fb5e2cc933303818987cf0" => :sierra
    sha256 "479f8ea0a7fb955007cd7304f6f21645519a25e7c09daacff174f2e5b3e6a309" => :el_capitan
  end

  depends_on :xcode => :build

  def install
    # ZIP for 1.10.1 additionally contains a `__MACOSX` directory, preventing
    # stripping of the first path component during extraction of the archive.
    mv Dir["The Unarchiver/*"], "."

    # Build XADMaster.framework, unar and lsar
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-alltargets", "-configuration", "Release", "clean", "SYMROOT=../"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "XADMaster", "SYMROOT=../", "-configuration", "Release"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "unar", "SYMROOT=../", "-configuration", "Release"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "lsar", "SYMROOT=../", "-configuration", "Release"

    bin.install "./Release/unar", "./Release/lsar"

    lib.install "./Release/libXADMaster.a"
    frameworks.install "./Release/XADMaster.framework"
    (include/"libXADMaster").install_symlink Dir["#{frameworks}/XADMaster.framework/Headers/*"]

    cd "./Extra" do
      man1.install "lsar.1", "unar.1"
      bash_completion.install "unar.bash_completion", "lsar.bash_completion"
    end
  end

  test do
    cp prefix/"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}/lsar README.md.gz")
    system bin/"unar", "README.md.gz"
    assert_predicate testpath/"README.md", :exist?
  end
end
