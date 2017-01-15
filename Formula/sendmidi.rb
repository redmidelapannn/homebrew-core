class Sendmidi < Formula
  desc "Multi-platform command-line tool to send out MIDI messages"
  homepage "https://github.com/gbevin/SendMIDI"
  url "https://github.com/gbevin/SendMIDI/archive/1.0.3.tar.gz"
  sha256 "f37a4ff16fac73e23e403fee0ed7ffb0eefcca399ed39dece9cd157969ad5fc6"

  bottle do
    cellar :any_skip_relocation
    sha256 "442494a25279c4eb627f5ff5f16680be5f3c211255b86c17c843880889c43acc" => :sierra
    sha256 "7cfc3978fc5d7be51778f0ce73c1d7270f372ed3d538653f7cd7dad0f6994f00" => :el_capitan
    sha256 "0596e44988e68495f7d6121acb5b292901ab818d53ce76d043243f8b92e8061b" => :yosemite
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "./Builds/MacOSX/sendmidi.xcodeproj", "-configuration", "Release", "SYMROOT=build"
    bin.install "./Builds/MacOSX/build/Release/sendmidi"
  end

  test do
    assert_match /Usage: sendmidi/, shell_output("#{bin}/sendmidi")
  end
end
