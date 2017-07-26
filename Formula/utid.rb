class Utid < Formula
  desc "Select default apps for documents and URL schemes on macOS. From 'duti'."
  homepage "https://github.com/jorvi/utid"
  url "https://github.com/jorvi/utid/archive/1.8.1.tar.gz"
  sha256 "b0d4a38a699e06ed43bbf485f661a0beb7ed0913ecece14a460d2007e88ae49d"
  head "https://github.com/jorvi/utid.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34b16220cbdc52a763dbbf1d5841b4c7b5f6d3c4154c07b35a4efa1b5eb3b38c" => :sierra
    sha256 "52feb3c475c281dbbbc7d026e68eabb91e795a3129b005b1182828c16e315036" => :el_capitan
    sha256 "77d80206483ff2ca759448850c2fdc70049d0ee147c0e6e99731ebfd35e17edb" => :yosemite
  end

  def install
    bin.mkpath
    system "make"
    bin.install "utid"
    man1.install "utid.1"
  end

  test do
    system "#{bin}/utid", "-x", "txt"
  end

end
