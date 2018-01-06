class Kr < Formula
  desc "Krypton command-line client, daemon, and SSH integration"
  homepage "https://krypt.co"

  stable do
    url "https://github.com/kryptco/kr.git", :tag => "2.3.0"
  end

  bottle do
    sha256 "13955792bdcb3c7e1a709d7fd02115c47ebff160d2503567c306ffd1cc03b65b" => :high_sierra
    sha256 "e40ea701349ef4803ecaa91ac4742321b1cd4ed299c32269777e94d696eb9aed" => :sierra
    sha256 "19b440800d7c1c56225122fc8f13819bb1a8a8af32b19f78c861f1aaaa230e7c" => :el_capitan
  end

  head do
    url "https://github.com/kryptco/kr.git"
  end

  option "with-no-ssh-config", "DEPRECATED -- export KR_SKIP_SSH_CONFIG=1 to prevent kr from changing ~/.ssh/config"

  depends_on "rust" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"

    dir = buildpath/"src/github.com/kryptco/kr"
    dir.install buildpath.children

    cd "src/github.com/kryptco/kr" do
      old_prefix = ENV["PREFIX"]
      ENV["PREFIX"] = prefix
      system "make", "install"
      ENV["PREFIX"] = old_prefix
    end
  end

  def caveats
    "kr is now installed! Run `kr pair` to pair with the Krypton app."
  end

  test do
    system "which kr && which krd"
  end
end
