class Bp4o < Formula
  desc "Better P4 Output"
  homepage "http://zachwhaleys.website/bp4o/"
  url "https://github.com/zachwhaley/bp4o/archive/v0.2.tar.gz"
  sha256 "610176c134432da43158a0c0ce2ae5831610624af32ef3106d27d87418cc0775"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fb8827e9d3a203391a2b99c771b1d4ea01a6bdd2e4ecf0f31bd23a372c1940d" => :sierra
    sha256 "1fb8827e9d3a203391a2b99c771b1d4ea01a6bdd2e4ecf0f31bd23a372c1940d" => :el_capitan
    sha256 "1fb8827e9d3a203391a2b99c771b1d4ea01a6bdd2e4ecf0f31bd23a372c1940d" => :yosemite
  end

  def install
    bin.install Dir["bin/*"]
    pkgshare.install Dir["./init.*"]
  end

  def post_install
    init = File.basename(ENV["SHELL"])
    ohai <<-EOS.undent
      BP4O Installed!
      Now add the following to your shell's rc file to setup BP4O on login

      source #{pkgshare}/init.#{init}
    EOS
  end
end
