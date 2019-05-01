class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag      => "0.23.1",
      :revision => "4870ca3e99887a7cd05dd3ba0ac9c5831922e1f3"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1995c67838730948f9efbfb63635eb4b019d6ea4149f1edfd583f085a8e4bf02" => :mojave
    sha256 "b60c690ee6737b35b9a08459b0c1d50c6cb4448df4afd812996714fa4d7e52e7" => :high_sierra
  end

  pour_bottle? do
    reason <<~EOS
      The bottle needs the [Swift 5 Runtime Support for Command Line Tools](https://support.apple.com/kb/DL1998) to be installed on macOS Mojave 10.14.3 or earlier.
        Alternatively, you can:
        * Update to macOS 10.14.4 or later
        * Install Xcode 10.2 or later at `/Applications/Xcode.app`
    EOS
    satisfy do
      MacOS.version < "10.14.0" ||
        (MacOS.version < "10.14.4" && (MacOS::Xcode.version >= "10.2" || File.directory?("/usr/lib/swift"))) ||
        MacOS.version >= "10.14.4"
    end
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end
