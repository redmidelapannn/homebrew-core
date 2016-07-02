class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/1.0.1.tar.gz"
  sha256 "9e23c62d8a7b10aac9293f215bed8f9e88a7042837130b00ca1b8a27f7c86c9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "de5f58e15c5d4477c3f085406db0361ba26d68500074921339f3f07bdc2c882c" => :el_capitan
    sha256 "4a3842c6064d0d9f26158f7334737395c98f23812f8be7058dae1fb84849f861" => :yosemite
    sha256 "1850d9468e4a1153098e7ef51892fc0ed09e43dea432c6e245ded503da672d75" => :mavericks
  end

  def install
    system "make", "all"
    bin.install "pngpaste"
  end

  test do
    png = test_fixtures("test.png")
    system "osascript", "-e", "set the clipboard to POSIX file (\"#{png}\")"
    system bin/"pngpaste", "test.png"
    assert File.exist? "test.png"
  end
end
