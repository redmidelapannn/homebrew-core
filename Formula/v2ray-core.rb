class V2rayCore < Formula
  desc "One platform for building proxies to bypass network restrictions."
  homepage "https://www.v2ray.com/"
  url "https://github.com/v2ray/v2ray-core/releases/download/v2.33/v2ray-macos.zip"
  version "1.4.3"
  sha256 "65506efa3810945b7506d00f237a65d399fe682558e869a41a4ee3f93011e287"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c28b7ce5c8381ab8b8e783534903ec58f27dbb4cefb39677c3f3ce7398defd4" => :sierra
    sha256 "9c28b7ce5c8381ab8b8e783534903ec58f27dbb4cefb39677c3f3ce7398defd4" => :el_capitan
    sha256 "9c28b7ce5c8381ab8b8e783534903ec58f27dbb4cefb39677c3f3ce7398defd4" => :yosemite
  end

  def install
      bin.install "v2ray"
      bin.install_symlink "v2ray" => "v2ray"
  end

  test do
    system "#{bin}/v2ray", "-version"
  end
end
