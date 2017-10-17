class Exomizer < Formula
  desc "6502 compressor with CBM PET 4032 support."
  homepage "https://bitbucket.org/magli143/exomizer/wiki/Home"
  url "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer209.zip"
  version "2.0.9"
  sha256 "d2a95d4d168e4007fc396295e2f30a21b58f4648c28d1aadf84e7d497c5c7a34"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "daf269e6178406a141027c15291ba5858d1e4ee38d8a0ab84d80509ef3526662" => :high_sierra
    sha256 "1381c2cfc7189343aaed87a6c606b94aa793b104abb7b28bb01aef9ca8210b46" => :sierra
    sha256 "7acc6086aa0ca6ab3fb4993339b6e8ad2d835a948241df1f4bbe25ac73e4eb23" => :el_capitan
  end

  def install
    cd "src" do
      system "make"
      bin.install %w[b2membuf exobasic exomizer exoraw]
    end
  end

  test do
    output = shell_output(bin/"exomizer -v")
    assert_match version.to_s, output
  end
end
