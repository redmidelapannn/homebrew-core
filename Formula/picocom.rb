class Picocom < Formula
  desc "Minimal dumb-terminal emulation program"
  homepage "https://github.com/npat-efault/picocom"
  url "https://github.com/npat-efault/picocom/archive/2.2.tar.gz"
  sha256 "3e3904158d675541f0fcfdcd1f671b38445338f536080f5de8d6674b5f33d4ce"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "538aefd7f5b885d8544c1d85a20e88207feabb5d9a7666795d8948e89a766125" => :sierra
    sha256 "faa4cc1321e160e65d483892f22661c0caefee8e82bf53252ba9f3318f978592" => :el_capitan
    sha256 "b995bd0f9b30368b95c8b3bd293ad9b00fed119223c967f0531724858412e0c7" => :yosemite
  end

  def install
    system "make"
    bin.install "picocom"
    man1.install "picocom.1"
  end

  test do
    system "#{bin}/picocom", "--help"
  end
end
