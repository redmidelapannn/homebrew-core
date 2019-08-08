class Gel < Formula
  desc "Modern gem manager"
  homepage "https://gel.dev"
  url "https://github.com/gel-rb/gel/archive/v0.3.0.tar.gz"
  sha256 "fe7c4bd67a2ea857b85b754f5b4d336e26640eda7199bc99b9a1570043362551"
  head "https://github.com/gel-rb/gel.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5f977248677f7bf1fff8f9219e0ee10ddca662c30c548f4f491ecbe77bb7c6f5" => :mojave
    sha256 "5f977248677f7bf1fff8f9219e0ee10ddca662c30c548f4f491ecbe77bb7c6f5" => :high_sierra
    sha256 "41a73fb829c4f2683e1662e97a48b39a8c51c403fbd3872348f7efd6e3c985bb" => :sierra
  end

  def install
    ENV["PATH"] = "bin:#{ENV["HOME"]}/.local/gel/bin:#{ENV["PATH"]}"
    system "gel", "install"
    system "rake", "man"
    bin.install "exe/gel"
    prefix.install "lib"
    man1.install Pathname.glob("man/man1/*.1")
  end

  test do
    (testpath/"Gemfile").write <<~EOS
      source "https://rubygems.org"
      gem "gel"
    EOS
    system "#{bin}/gel", "install"
  end
end
