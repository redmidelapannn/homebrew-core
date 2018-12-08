class Npush < Formula
  desc "Logic game simliar to Sokoban and Boulder Dash"
  homepage "https://npush.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/npush/npush/0.7/npush-0.7.tgz"
  sha256 "f216d2b3279e8737784f77d4843c9e6f223fa131ce1ebddaf00ad802aba2bcd9"
  head "https://svn.code.sf.net/p/npush/code/"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2516fd97194e5e936df66a7a041dcb4e546ccd441eca2b45434445b89b01abd3" => :mojave
    sha256 "bd1ce0ee794baa420fd660caa386b920e360e62d2ee87985c761c6cdbc0b627b" => :high_sierra
    sha256 "9df89edec8cd9dc9f81ff6fe77d60fa12f9d22bd805cd107f5a279518efda12d" => :sierra
  end

  def install
    system "make"
    pkgshare.install ["npush", "levels"]
    (bin/"npush").write <<~EOS
      #!/bin/sh
      cd "#{pkgshare}" && exec ./npush $@
    EOS
  end
end
