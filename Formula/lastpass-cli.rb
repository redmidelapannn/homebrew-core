class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.2.1.tar.gz"
  sha256 "1a49a37a67a973296e218306e6d36c9383347b1833e5a878ebc08355b1c77456"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "32289fc652852cc950a3e8ac9cdc912168a5ba420ed98d8e292bf82c692f5def" => :high_sierra
    sha256 "e88349774ef9dff193d67bf6c7685ab4f5fbf62545c2d014bcbf7180861dfc95" => :sierra
    sha256 "24282f9da4ab82f8332be67b73bfd5c741d4ede55266c065bb05f8345749ee39" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "pinentry" => :optional

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "PREFIX=#{prefix}", "install"
    system "make", "MANDIR=#{man}", "install-doc"
  end

  test do
    system "#{bin}/lpass", "--version"
  end
end
