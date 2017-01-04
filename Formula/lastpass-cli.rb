class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.0.0.tar.gz"
  sha256 "42096c0bd3972b0e9cc9cef32fbf141e47b04b9e2387fb3abe8b105e135fb41e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b6a6c911b92ebbae2c0c920e70f8c71c15546e537de5de4eb1f229945e5a7239" => :sierra
    sha256 "84f28f586f5d524156e7030902fba1bbfd264dfb67676272822e62d6218e691b" => :el_capitan
    sha256 "ebcce42f55829d4357a54c7545d5adeabc8939b166039620d7859bb51fd65dd0" => :yosemite
  end

  head do
    url "https://github.com/lastpass/lastpass-cli.git"
    
    depends_on "cmake" => :build
  end
  
  option "with-doc", "Install man pages"

  depends_on "asciidoc" => :build if build.with? "doc"
  depends_on "openssl"
  depends_on "pinentry" => :optional

  def install
    system "make", "PREFIX=#{prefix}", "install"
    system "make", "MANDIR=#{man}", "install-doc" if build.with? "doc"
  end

  test do
    system "#{bin}/lpass", "--version"
  end
end
