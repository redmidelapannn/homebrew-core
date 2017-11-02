class IrssiXmpp < Formula
  desc "Irssi plugin to connect to the Jabber network"
  homepage "https://cybione.org/~irssi-xmpp/"
  url "https://github.com/cdidier/irssi-xmpp/archive/v0.54.tar.gz"
  sha256 "1033cc6bf03abaacdb083e1fbe7d75d8a62622339e06d889422d8f0705fa7776"
  head "https://github.com/cdidier/irssi-xmpp.git"

  bottle do
    cellar :any
    sha256 "14c6770f82f8f2199409a448aac73cdff74d5937c0b7af272697efa7e8dee2de" => :high_sierra
    sha256 "9205d0d1c452f1c253ebd08f6f6764311ae8855fb1b88fa91e43dd2af1ff93ea" => :sierra
    sha256 "35b745953c7589e6f7a65066dc7ef275f60489709d0d042b4eb2f7409be1f256" => :el_capitan
  end

  depends_on "glib"
  depends_on "irssi"
  depends_on "loudmouth"
  depends_on "pkg-config" => :build

  def install
    ENV.prepend "LDFLAGS", "-flat_namespace -undefined warning"
    ENV["PREFIX"] = prefix
    ENV["IRSSI_INCLUDE"] = Formula["irssi"].include/"irssi"
    system "make", "install"
  end

  def caveats; <<~EOS
    To load the plugin add:
      /load #{opt_prefix}/lib/irssi/modules/libxmpp
    to your ~/.irssi/startup
    EOS
  end

  test do
    system "true"
  end
end
