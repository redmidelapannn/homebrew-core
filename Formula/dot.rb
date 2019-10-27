class Dot < Formula
  desc "Yet another management tool for dotfiles"
  homepage "https://github.com/ubnt-intrepid/dot"
  url "https://github.com/ubnt-intrepid/dot/archive/v0.1.4.tar.gz"
  sha256 "7f043f5a0e59b08f36c98e7117a65e5bbfdc927b0b55103e8de0cad5c94d6c1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e849e181a0cd8cdb37137bdaade636b8343fcf043374efc63f81c4b380e4e8a6" => :catalina
    sha256 "326a5dfb197b5d73ec253f6de86335fbc29cb1d33c9d074ab1b8eb0c9208d13d" => :mojave
    sha256 "69b7ef4f13d2ad9309dc2b4ed91d4a4d7b3ccb852f32498c6e678c879582e39e" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "dot", "root"
  end
end
