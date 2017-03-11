class Npush < Formula
  desc "Logic game simliar to Sokoban and Boulder Dash"
  homepage "https://npush.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/npush/npush/0.7/npush-0.7.tgz"
  sha256 "f216d2b3279e8737784f77d4843c9e6f223fa131ce1ebddaf00ad802aba2bcd9"
  head "https://svn.code.sf.net/p/npush/code/"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a0785fc0f3f74716624b6a318a57943fa47b8b79fc3081a269bdd77b5f36d73b" => :sierra
    sha256 "68d69ab19dd1932d3dc20ea1119d6fb32f69d4c7b97ba27477cdf202883f93fe" => :el_capitan
    sha256 "e4af937967cafe81d53e010f2a13ef5bf33c3cb346dac0f7e39f2247d92b4524" => :yosemite
  end

  def install
    system "make"
    pkgshare.install ["npush", "levels"]
    (bin/"npush").write <<-EOS.undent
      #!/bin/sh
      cd "#{pkgshare}" && exec ./npush $@
      EOS
  end
end
