class WechatPlugin < Formula
  desc "Powerful assistant for wechat macOS"
  homepage "https://github.com/TKkk-iOSer/WeChatPlugin-MacOS"
  url "https://github.com/TKkk-iOSer/WeChatPlugin-MacOS/archive/v1.7.2.tar.gz"
  sha256 "80a079c71c6aba93197603310258bf25567a0df3ae969404f9a2de58372363de"

  bottle do
    cellar :any
    sha256 "6246b0f25bcd2aa9191761b72cebf00e621bb456d96fb3933ae953a8301c5bee" => :mojave
    sha256 "3bdb537dba51a6603efbb34282d4399d1dcd01239e96bcfc9fe2d45bccf8f391" => :high_sierra
    sha256 "3bdb537dba51a6603efbb34282d4399d1dcd01239e96bcfc9fe2d45bccf8f391" => :sierra
  end

  def install
    pkgshare.install ["Other"]
  end

  def caveats; <<~EOS
    To install the plugin:
    sudo #{HOMEBREW_PREFIX}/share/wechat-plugin/Other/install.sh

    To uninstall the plugin:
    sudo #{HOMEBREW_PREFIX}/share/wechat-plugin/Other/uninstall.sh

  EOS
  end

  test do
    system "test", "-d", "/Applications/WeChat.app/Contents/MacOS/WeChatPlugin.framework"
  end
end
