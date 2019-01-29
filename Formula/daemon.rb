class Daemon < Formula
  desc "Turn other processes into daemons"
  homepage "http://libslack.org/daemon/"
  url "http://libslack.org/daemon/download/daemon-0.6.4.tar.gz"
  sha256 "c4b9ea4aa74d55ea618c34f1e02c080ddf368549037cb239ee60c83191035ca1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "04dc5cd0a00ced6829200e710b8b62f0041d427aa3c3f5ce3e8cfa67f8f8ea47" => :mojave
    sha256 "583b9dee59d8a86ceb8b2a555da16a6dcd24f99ef9f401e5cc1c878dd8f6cc95" => :high_sierra
    sha256 "d9c56811f6825e9c040d90abfdf52d881785396bbc2ed0b573fa7fdfa09c126c" => :sierra
  end

  # fixes for strlcpy/strlcat: https://trac.macports.org/ticket/42845
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3323958/daemon/daemon-0.6.4-ignore-strlcpy-strlcat.patch"
    sha256 "a56e16b0801a13045d388ce7e755b2b4e40288c3731ce0f92ea879d0871782c0"
  end

  def install
    # Parallel build failure reported to raf@raf.org 27th Feb 2016
    ENV.deparallelize

    system "./config"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
