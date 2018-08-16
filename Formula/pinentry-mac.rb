class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry-mac"
  url "https://github.com/GPGTools/pinentry-mac/archive/v0.9.4.tar.gz"
  sha256 "037ebb010377d3a3879ae2a832cefc4513f5c397d7d887d7b86b4e5d9a628271"
  head "https://github.com/GPGTools/pinentry-mac.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "22f2eb8913fcd4241885a7739119d604791fcbe78f72a54d2d8981bd1103536a" => :high_sierra
    sha256 "5b89032e22a908676d1ab5544334442be7c5066340f8287d3e4270db9c29c314" => :sierra
    sha256 "92692077ad0b2de626aa6b2035a44c0f0ed7fd40105359c1ba9a71979a25665c" => :el_capitan
  end

  depends_on :xcode => :build

  patch do
    # patch header locations for macOS 10.14
    url "https://github.com/GPGTools/pinentry-mac/pull/7.patch?full_index=1"
    sha256 "d4bcf2003fa1345ecb1809461140179a3737e8e03eb49d623435beb3c2f09b64"
  end

  def install
    system "make"
    prefix.install "build/Release/pinentry-mac.app"
    bin.write_exec_script "#{prefix}/pinentry-mac.app/Contents/MacOS/pinentry-mac"
  end

  def caveats; <<~EOS
    You can now set this as your pinentry program like

    ~/.gnupg/gpg-agent.conf
        pinentry-program #{HOMEBREW_PREFIX}/bin/pinentry-mac
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinentry-mac --version")
  end
end
