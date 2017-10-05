class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "http://vicerveza.homeunix.net/~viric/soft/ts/"
  url "http://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.tar.gz"
  sha256 "4f53e34fff0bb24caaa44cdf7598fd02f3e5fa7cacaea43fa0d081d03ffbb395"

  bottle do
    cellar :any_skip_relocation
    sha256 "a44646a9142dc1bf4d8b036f6853002cdb925912c938e38e271a82ee732c6477" => :high_sierra
    sha256 "0a56e3d68bf1b7023f953d38f3a9f9be4b9dc6e0ffb5032a6eafd57ada27c048" => :sierra
    sha256 "8db4855e85381d623d2d4e82d51683cb4b6087b8f319cf1fd56f3a703105a653" => :el_capitan
  end

  conflicts_with "moreutils",
    :because => "both install a 'ts' executable."

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/ts, "-V"
  end
end
