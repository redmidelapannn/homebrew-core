class Npush < Formula
  desc "Logic game simliar to Sokoban and Boulder Dash"
  homepage "https://npush.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/npush/npush/0.7/npush-0.7.tgz"
  sha256 "f216d2b3279e8737784f77d4843c9e6f223fa131ce1ebddaf00ad802aba2bcd9"
  head "https://svn.code.sf.net/p/npush/code/"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7fb5963eb161a4131a09a3cff0232bff9fd5145699e244f6ccc28b1392d0e89e" => :mojave
    sha256 "a4a328c5cde437ed0a0dfd3108b8fdc908cca80fab1de45998da7d9ce5a937cd" => :high_sierra
    sha256 "1f54e2553f41dbb2912915392c6e1d4dae7038acac9799f6146ae644b02259a5" => :sierra
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
