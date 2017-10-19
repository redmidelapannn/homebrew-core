class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20170509.tgz"
  mirror "https://fossies.org/linux/misc/dialog-1.3-20170509.tgz"
  sha256 "2ff1ba74c632b9d13a0d0d2c942295dd4e8909694eeeded7908a467d0bcd4756"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "514aefbc8e33917710253e707084cc0f1f7c27e98a8b30e23a2d6ba8da7f0941" => :high_sierra
    sha256 "0c15863087aa926b776da0b891d8f6b6b1ba78e1bc0c5d90734eaa9d88a6e838" => :sierra
    sha256 "4381c9b8b7b55f26e52b8ce0d687a704cdfde5111752c008b3c61c53fbaadb95" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
