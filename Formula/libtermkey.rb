class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.19.tar.gz"
  sha256 "c505aa4cb48c8fa59c526265576b97a19e6ebe7b7da20f4ecaae898b727b48b7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bc9ba2425bf0c3e046feb78c795551b0c99457dd49b461721490e5c79061d78b" => :sierra
    sha256 "ecf695b648d49ba88e952e9d8f2a6f71e2c31dffea1bcc41682d062dbc0bc216" => :el_capitan
    sha256 "2074b2e34722133c9d3127df0fb3c67e7b0e1c3234cd878d026d59156b7a5cfc" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
