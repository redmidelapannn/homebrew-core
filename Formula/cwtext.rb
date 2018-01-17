class Cwtext < Formula
  desc "Morse Code Generator"
  homepage "https://cwtext.sourceforge.io"
  url "https://downloads.sourceforge.net/project/cwtext/cwtext/cwtext%200.96/cwtext-0.96.tar.gz"
  sha256 "db108e6f510583edf4a285c6d6ab9ab9fdffa3bc5682903b316fd10e1e12393e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a0dc3fe73f6c2d22387b7c9835a79e14e67c39d2a68310ab7e82e46081336c8" => :high_sierra
    sha256 "19da9190e20508251496688c2d93effe0953673c5a2f67271fae9716f5804ffa" => :sierra
    sha256 "afad4f5b910ebf831d37544a2b0ca1c6bd9c78a77088949028351f908f3c7d6f" => :el_capitan
  end

  def install
    bin.mkpath

    ENV.append "CFLAGS", "-Wno-return-type"

    system "make", "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}",
                   "install"
  end

  test do
    system "true"
  end
end
