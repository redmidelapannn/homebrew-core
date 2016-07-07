class XdebugOsx < Formula
  desc "Simple bash script to toggle xdebug on/off in OSX"
  homepage "https://github.com/w00fz/xdebug-osx"
  url "https://github.com/w00fz/xdebug-osx/archive/1.0.tar.gz"
  sha256 "42b4f06422838083efa9bfe1d545f369802ba62c224c4cb54694e40dc1966725"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a60e21e38ce0f5f6434241191ac3a6ea04276f14e4742bf815238150aba0923" => :el_capitan
    sha256 "6b468574be51f31cfb2a26e9de786db9823be1aaedfb5aa6685834315b3a8edf" => :yosemite
    sha256 "6b47731adcb72108511f70d231715793b7f99a420ca2999900289a6e76eddd9a" => :mavericks
  end

  def install
    bin.install "xdebug"
  end

  def caveats; <<-EOS.undent
    Only for PHP and Xdebug installed via Homebrew!

    Usage:
      xdebug       # outputs the current status
      xdebug on    # enables xdebug
      xdebug off   # disables xdebug
    EOS
  end

  test do
    system "#{bin}/xdebug"
  end
end
