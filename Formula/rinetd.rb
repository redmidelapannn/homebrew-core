class Rinetd < Formula
  desc "Internet TCP redirection server"
  homepage "https://www.boutell.com/rinetd/"
  url "https://www.boutell.com/rinetd/http/rinetd.tar.gz"
  version "0.62"
  sha256 "0c68d27c5bd4b16ce4f58a6db514dd6ff37b2604a88b02c1dfcdc00fc1059898"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "7bbeb35182819c5ffd0aabc81020332b0763642dcb791657e8a54e64a18686d8" => :el_capitan
    sha256 "88469a8ca5f6676cf3d41efb0e471be5dfcba53c5c58beaf7835b7df5dc6156b" => :yosemite
    sha256 "992653920d80b985a6a54be1b47932fe901ac02b47cbde60057f511aca5d993e" => :mavericks
  end

  def install
    inreplace "rinetd.c" do |s|
      s.gsub! "/etc/rinetd.conf", "#{etc}/rinetd.conf"
      s.gsub! "/var/run/rinetd.pid", "#{var}/rinetd.pid"
    end

    inreplace "Makefile" do |s|
      s.gsub! "/usr/sbin", sbin
      s.gsub! "/usr/man", man
    end

    sbin.mkpath
    man8.mkpath

    system "make", "install"

    conf = etc/"rinetd.conf"
    unless conf.exist?
      conf.write <<-EOS.undent
        # forwarding rules go here
        #
        # you may specify allow and deny rules after a specific forwarding rule
        # to apply to only that forwarding rule
        #
        # bindadress bindport connectaddress connectport
      EOS
    end
  end

  test do
    system "#{sbin}/rinetd", "-h"
  end
end
